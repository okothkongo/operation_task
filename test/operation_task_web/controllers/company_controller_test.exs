defmodule Todos.TodoControllerTest do
  use OperationTaskWeb.ConnCase
  alias OperationTask.Companies
  alias OperationTask.Repo
  alias OperatioTask.Companies.Company

  test "#index renders a list of companies", %{conn: conn} do
    companies_fixture()
    conn = get(conn, Routes.company_path(conn, :index))
    assert %{"data" => [%{"category" => category}]} = json_response(conn, 200)
    assert category == "TECH"
  end

  test "#new_companies renders a list of new companies whose inseterted_at are equal to given timestamp",
       %{
         conn: conn
       } do
    companies_fixture()
    %{inserted_at: timestamp} = Repo.get_by(Company, name: "Apple")
    timestamp = NaiveDateTime.to_iso8601(timestamp)

    assert %{"data" => [%{"category" => category}]} =
             conn
             |> get(Routes.company_path(conn, :new_companies, timestamp))
             |> json_response(200)

    assert category == "TECH"
  end

  test "#new_companies renders a list of new companies whose inseterted_at are greater than given timestamp",
       %{
         conn: conn
       } do
    companies_fixture()

    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(-3600, :second)
      |> NaiveDateTime.to_iso8601()

    assert %{"data" => [%{"category" => category}]} =
             conn
             |> get(Routes.company_path(conn, :new_companies, timestamp))
             |> json_response(200)

    assert category == "TECH"
  end

  test "#new_companies renders an list empty when  inseterted_at less than given timestamp",
       %{
         conn: conn
       } do
    companies_fixture()

    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(3600, :second)
      |> NaiveDateTime.to_iso8601()

    assert %{"data" => []} ==
             conn
             |> get(Routes.company_path(conn, :new_companies, timestamp))
             |> json_response(200)
  end

  test "#new_companies renders error when  given invalid timestamp",
       %{
         conn: conn
       } do
    assert %{"error" => "invalid_date_time_format"} ==
             conn
             |> get(Routes.company_path(conn, :new_companies, "1"))
             |> json_response(422)
  end

  defp companies_fixture do
    companies = [
      %{
        "category" => "TECH",
        "country" => "USA",
        "name" => "Apple",
        "stock_market" => "NYSE",
        "stock_price" => 1000
      }
    ]

    Companies.insert_all_companies(companies)
  end
end

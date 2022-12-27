defmodule OperationTask.CompaniesTest do
  use OperationTask.DataCase
  alias OperationTask.Companies

  test "insert_all_companies/1 inserts given record to db" do
    assert [ok: {2, nil}] == insert_companies()
    assert Companies.list_companies() |> length == 2
  end

  test "all_companies/0  return all companies" do
    insert_companies()
    assert Companies.list_companies() |> length == 2
  end

  test "get_latest_companies/1  new companies whose insertion date equal or greater than timestamp given" do
    insert_companies()
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.add(-50, :second) |> to_iso8601()
    assert {:ok, companies} = Companies.get_latest_companies(timestamp)
    assert companies |> length() == 2
  end

  test "get_latest_companies/1  with t invalid timestamp format return error " do
    assert {:error, :invalid_date_time_format} ==
             Companies.get_latest_companies("1")
  end

  defp insert_companies() do
    companies = [
      %{
        "category" => "Health",
        "country" => "USA",
        "name" => "Nader and Sons",
        "stock_market" => "S",
        "stock_price" => 498.39,
        "timestamp" => NaiveDateTime.utc_now() |> to_iso8601()
      },
      %{
        "category" => "TECH",
        "country" => "USA",
        "name" => "Apple",
        "stock_market" => "NYSE",
        "stock_price" => 1000,
        "timestamp" => NaiveDateTime.utc_now() |> to_iso8601()
      }
    ]

    OperationTask.Companies.insert_all_companies(companies)
  end

  defp to_iso8601(datetime) do
    NaiveDateTime.to_iso8601(datetime)
  end
end

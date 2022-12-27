defmodule OperationTask.CompaniesTest do
  use OperationTask.DataCase
  import Ecto.Query

  test "OperationTask.Companies.insert_all_companies/1 inserts given record to db" do
    companies = [
      %{
        "category" => "Health",
        "country" => "USA",
        "name" => "Nader and Sons",
        "stock_market" => "S",
        "stock_price" => 498.39
      },
      %{
        "category" => "TECH",
        "country" => "USA",
        "name" => "Apple",
        "stock_market" => "NYSE",
        "stock_price" => 1000
      }
    ]

    assert [ok: {2, nil}] == OperationTask.Companies.insert_all_companies(companies)
    query = from(c in "companies", select: c.name)
    assert query |> OperationTask.Repo.all() |> length == 2
  end
end

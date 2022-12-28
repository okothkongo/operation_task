defmodule OperatioTask.Companies.Company do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field(:name, :string)
    field(:category, :string)
    field(:country, :string)
    field(:stock_price, :float)
    field(:stock_market, :string)
    field(:symbol, :string)
    field(:currency, :string)
    field(:timestamp, :string)
    field(:inserted_at, :naive_datetime)
  end

  def changeset(company, attrs \\ %{}) do
    company
    |> cast(attrs, ~w(name category country stock_price stock_market symbol currency timestamp)a)
  end
end

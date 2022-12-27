defmodule OperationTask.Repo.Migrations.CompaniesTable do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :country, :string
      add :currency, :string
      add :stock_market, :string
      add :stock_price, :float
      add :name, :string
      add :symbol, :string
      add :category, :string
      add :inserted_at, :naive_datetime, default:  fragment("NOW()::timestamp")

    end
  end
end
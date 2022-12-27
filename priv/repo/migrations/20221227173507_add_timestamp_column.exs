defmodule OperationTask.Repo.Migrations.AddTimestampColumn do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :timestamp, :string
    end
  end
end

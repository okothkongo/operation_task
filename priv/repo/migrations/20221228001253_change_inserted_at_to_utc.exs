defmodule OperationTask.Repo.Migrations.ChangeInsertedAtToUtc do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      modify :inserted_at,:utc_datetime,  default:  fragment("NOW() AT TIME ZONE 'utc'")
   
    end
  end
end

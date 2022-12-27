defmodule OperationTask.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :fav_categories, {:array,:string}
    end
    create unique_index(:users, [:email])
  end
end
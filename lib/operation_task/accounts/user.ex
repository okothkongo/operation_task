defmodule OperationTask.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:fav_categories, {:array, :string})
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :fav_categories])
    |> validate_required(:email)
  end
end

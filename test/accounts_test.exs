defmodule OperationTask.AccountssTest do
  use OperationTask.DataCase
  alias OperationTask.Accounts
  alias OperationTask.Accounts.User

  test "get_user_favorite_category_from_new_companies/1 send notification users" do
    company_attrs = [
      %{
        "name" => "name",
        "stock_price" => System.unique_integer([:positive]),
        "category" => "TECH"
      }
    ]

    user_attrs = %User{
      first_name: "Jane",
      last_name: "Doe",
      email: "janedoe@gmail",
      fav_categories: ["TECH"]
    }

    OperationTask.Companies.insert_all_companies(company_attrs)

    OperationTask.Repo.insert(user_attrs)

    assert [{:ok, email}] = Accounts.send_new_companies_email_notification(company_attrs)
    assert email.text_body == "A new company of category TECH has been added kindly check it out"
  end
end

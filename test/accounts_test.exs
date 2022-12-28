defmodule OperationTask.AccountssTest do
  use OperationTask.DataCase
  alias OperationTask.Accounts
  alias OperationTask.Accounts.User

  @company_attrs [
    %{
      "name" => "name",
      "stock_price" => System.unique_integer([:positive]),
      "category" => "TECH"
    },
    %{
      "name" => "name",
      "stock_price" => System.unique_integer([:positive]),
      "category" => "FARMING"
    }
  ]
  test "get_user_favorite_category_from_new_companies/1 send notification users" do
    create_user(["TECH"])

    create_companies()

    assert [{:ok, email}] = Accounts.send_new_companies_email_notification(@company_attrs)
    assert email.text_body == "A new company of category TECH has been added kindly check it out"
  end

  test "get_user_favorite_category_from_new_companies/1 do not send email there when is no user favorite category in the companies categories" do
    create_companies()
    create_user(["DEFENCE"])
    assert Accounts.send_new_companies_email_notification(@company_attrs) == []
  end

  test "get_user_favorite_category_from_new_companies/1 sends number of  emails to user matching their favorite category companies" do
    create_companies()
    create_user(["FARMING", "TECH"])

    assert [{:ok, email1}, {:ok, email2}] =
             Accounts.send_new_companies_email_notification(@company_attrs)

    assert email1.text_body == "A new company of category TECH has been added kindly check it out"

    assert email2.text_body ==
             "A new company of category FARMING has been added kindly check it out"
  end

  test "get_user_favorite_category_from_new_companies/1 only send emails to user with favorite category" do
    create_companies()
    create_user(["FARMING", "TECH"])
    create_user(["DEFENCE", "ED"])

    assert [{:ok, email1}, {:ok, email2}] =
             Accounts.send_new_companies_email_notification(@company_attrs)

    [nil: email_address1] = email1.to
    [nil: email_address2] = email2.to
    assert email_address1 == email_address2
  end

  defp create_companies do
    OperationTask.Companies.insert_all_companies(@company_attrs)
  end

  defp create_user(favorite_categories) do
    user_attrs = %User{
      first_name: "Jane",
      last_name: "Doe",
      email: "janedoe#{System.unique_integer([:positive])}@gmail.com",
      fav_categories: favorite_categories
    }

    OperationTask.Repo.insert(user_attrs)
  end
end

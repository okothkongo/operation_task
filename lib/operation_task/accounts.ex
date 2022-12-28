defmodule OperationTask.Accounts do
  alias OperationTask.Accounts.User
  alias OperationTask.Emails.Email
  alias OperationTask.Mailer
  alias OperationTask.Repo
  import Ecto.Query

  @doc """
    Send email to notifications to user when new companies has the their favorite category
  """

  @spec send_new_companies_email_notification(list()) :: list()
  def send_new_companies_email_notification(new_companies) do
    new_companies
    |> get_user_favorite_category_from_new_companies
    |> Task.async_stream(fn %{category: category, email: email} ->
      email
      |> Email.email_notification_content(category)
      |> Mailer.deliver_later!()
    end)
    |> Enum.to_list()
  end

  defp get_user_favorite_category_from_new_companies(companies) do
    companies
    |> Stream.flat_map(fn %{"category" => category} ->
      Repo.all(
        from(u in User,
          where: ^category in u.fav_categories,
          select: %{email: u.email, category: ^category}
        )
      )
    end)
  end
end

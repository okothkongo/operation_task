defmodule OperationTask.Emails.Email do
  import Bamboo.Email

  def email_notification_content(receiver_email, category) do
    new_email(
      to: receiver_email,
      from: "support@operation_task.com",
      subject: "New Companies Alert!.",
      text_body: "A new company of category #{category} has been added kindly check it out"
    )
  end
end

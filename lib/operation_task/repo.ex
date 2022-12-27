defmodule OperationTask.Repo do
  use Ecto.Repo,
    otp_app: :operation_task,
    adapter: Ecto.Adapters.Postgres
end

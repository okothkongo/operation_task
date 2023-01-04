start_apps = [
  :postgrex,
  :ecto_sql
]

repos = Application.get_env(:operation_task, :ecto_repos, [])
Enum.each(start_apps, &Application.ensure_all_started/1)
Enum.each(repos, & &1.start_link(pool_size: 10))
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(OperationTask.Repo, :manual)

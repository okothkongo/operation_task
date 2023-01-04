alias OperationTask.Accounts.User 
start_apps = [
  :postgrex,
  :ecto_sql 
]
repos  = Application.get_env(:operation_task, :ecto_repos, []) 
Enum.each(start_apps, &Application.ensure_all_started/1)
Enum.each(repos, & &1.start_link(pool_size: 10))

1..100
|> Enum.each(fn _num ->
  %User{
    first_name: "name#{Enum.random(1..500)}",
    last_name: "doe#{Enum.random(1..500)}",
    email: "janedoe#{System.unique_integer([:positive])}@gmail.com",
    fav_categories: ["TBD-2022#{Enum.random(1..15)}"]
  }
  |> OperationTask.Repo.insert!()
  
end)

alias OperationTask.Accounts.User 

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
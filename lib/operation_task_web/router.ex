defmodule OperationTaskWeb.Router do
  use OperationTaskWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OperationTaskWeb do
    pipe_through :api
  end
end

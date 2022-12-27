defmodule OperationTaskWeb.Router do
  use OperationTaskWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OperationTaskWeb do
    pipe_through :api
    get "/companies", CompanyController, :index
    get "/companies/:timestamp", CompanyController, :new_companies
  end
end

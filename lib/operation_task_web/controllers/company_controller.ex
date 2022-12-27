defmodule OperationTaskWeb.CompanyController do
  use OperationTaskWeb, :controller
  alias OperationTask.Companies
  action_fallback OperationTaskWeb.FallbackController

  def index(conn, _params) do
    companies = Companies.list_companies()
    render(conn, "index.json", companies: companies)
  end

  def new_companies(conn, %{"timestamp" => timestamp}) do
    with {:ok, companies} <- Companies.get_latest_companies(timestamp) do
      render(conn, "new_companies.json", companies: companies)
    end
  end
end

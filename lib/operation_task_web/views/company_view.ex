defmodule OperationTaskWeb.CompanyView do
  use OperationTaskWeb, :view

  def render("index.json", %{companies: companies}) do
    %{data: Enum.map(companies, &company_json/1)}
  end

  def render("new_companies.json", %{companies: companies}) do
    %{data: Enum.map(companies, &company_json/1)}
  end

  def render("422.json", %{error: error}) do
    %{error: error}
  end

  def company_json(company) do
    %{
      name: company.name,
      category: company.category,
      inserted_at: company.inserted_at,
      timestamp: company.timestamp,
      stock_price: company.stock_price,
      stock_market: company.stock_market,
      country: company.country,
      symbol: company.symbol,
      currency: company.currency
    }
  end
end

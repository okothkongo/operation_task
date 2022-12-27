# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :operation_task, OperationTaskWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: OperationTaskWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: OperationTask.PubSub,
  live_view: [signing_salt: "DZ5YpV+J"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# enviromental variables
config :operation_task,
  stock_market_provider_base_url: System.get_env("Stock_Market_Provider_BASEURL")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

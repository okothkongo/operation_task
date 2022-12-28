import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.

config :operation_task, OperationTask.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "operation_task_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :operation_task, OperationTaskWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bvQC2kGHt4RADklHX7Gh8eP4/kot6dJUh//7jGqfvoFVV815kvOzeaiQ85n8ZgOe",
  server: false

config :operation_task,
  stock_market_provider_api_url: ""

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :operation_task, OperationTask.Mailer, adapter: Bamboo.TestAdapter

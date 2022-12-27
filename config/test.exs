import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :operation_task, OperationTaskWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bvQC2kGHt4RADklHX7Gh8eP4/kot6dJUh//7jGqfvoFVV815kvOzeaiQ85n8ZgOe",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

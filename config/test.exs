use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tpl, TplWeb.Endpoint,
  http: [port: 4002],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :tpl, Tpl.Repo,
  username: "postgres",
  password: "postgres",
  database: "tpl_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :tpl, :sql_sandbox, true

config :wallaby, driver: Wallaby.Experimental.Chrome

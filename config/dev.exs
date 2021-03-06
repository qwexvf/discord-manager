use Mix.Config

# Configure your database
config :discord_manager, DiscordManager.Repo,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres" ,
  database: "discord_manager_dev",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :discord_manager, DiscordManager.Guardian,
   issuer: "my_app",
   secret_key: "Secret key. You can use `mix guardian.gen.secret` to get one"

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :discord_manager_web, DiscordManagerWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :discord_manager, DiscordManager.Guardian,
       issuer: "discord_manager",
       secret_key: "Secret key. You can use `mix guardian.gen.secret` to get one"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :discord_manager,
  ecto_repos: [DiscordManager.Repo]

config :discord_manager_web,
  ecto_repos: [DiscordManager.Repo],
  generators: [context_app: :discord_manager]

# Configures the endpoint
config :discord_manager_web, DiscordManagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MPBSXGJPPMd5JfKzHvfCslPeoKp6qSFMMfVkkQCd75Rd7crI/eEaormg0RqtE1FA",
  render_errors: [view: DiscordManagerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: DiscordManager.PubSub,
  live_view: [signing_salt: "t/YdbDVX"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

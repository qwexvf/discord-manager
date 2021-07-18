defmodule DiscordManager.Repo do
  use Ecto.Repo,
    otp_app: :discord_manager,
    adapter: Ecto.Adapters.Postgres
end

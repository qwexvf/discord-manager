defmodule DiscordManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      DiscordManager.Repo,
      {Phoenix.PubSub, name: DiscordManager.PubSub},
      {Oban, oban_config()}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: DiscordManager.Supervisor)
  end

  # Conditionally disable queues or plugins here.
  defp oban_config do
    Application.fetch_env!(:discord_manager, Oban)
  end
end

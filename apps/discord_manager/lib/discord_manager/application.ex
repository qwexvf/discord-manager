defmodule DiscordManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DiscordManager.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: DiscordManager.PubSub}
      # Start a worker by calling: DiscordManager.Worker.start_link(arg)
      # {DiscordManager.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: DiscordManager.Supervisor)
  end
end

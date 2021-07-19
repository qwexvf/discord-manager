defmodule DiscordManagerWeb.Resolvers.ScheduleResolver do
  alias DiscordManager.{Servers}

  def list(_, %{}, _) do
    schedules = Servers.list_schedules()
    {:ok, schedules}
  end

  def run_all(_, %{}, _) do
    Servers.run_all()
    {:ok, true}
  end
end

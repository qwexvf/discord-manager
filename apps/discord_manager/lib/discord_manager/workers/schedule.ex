defmodule DiscordManager.Workers.ScheduleWorker do
  use Oban.Worker, queue: :events
  alias DiscordManager.{Servers}

  @impl Oban.Worker
  def perform(%Oban.Job{} = job) do
    IO.inspect job
  end
end

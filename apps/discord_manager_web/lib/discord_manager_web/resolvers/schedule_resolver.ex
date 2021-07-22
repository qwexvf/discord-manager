defmodule DiscordManagerWeb.Resolvers.ScheduleResolver do
  alias DiscordManager.{Servers}
  alias DiscordManager.Servers.Schedule

  def list(_, %{}, %{context: %{current_user: current_user}}) do
    schedules = Servers.list_schedules(current_user.id)
    {:ok, schedules}
  end

  def run_all(_, %{}, _) do
    Servers.run_all()
    {:ok, true}
  end

  def update_schedule(_, %{attrs: %{message: message, schedule_id: id}}, %{context: %{current_user: current_user}}) do
    with %Schedule{} = schedule <- Servers.get_schedule!(id, current_user.id),
         {:ok, updatedSchedule} <- Servers.update_schedule(schedule, current_user.id, %{message: message}) do
      schedule = Servers.get_schedule!(schedule.id, current_user.id)
      {:ok, schedule}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, changeset}
    end
  end

  def create_schedule(_, %{attrs: %{message: message}},
    %{context: %{current_user: current_user}}) do
    with {:ok, schedule} <- Servers.create_schedule(current_user.id, %{message: message}) do
      {:ok, schedule}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, changeset}
    end
  end

  def delete_schedule(_, %{"id" => id}, _) do
    Servers.delete_schedule(id)
    {:ok, true}
  end
end

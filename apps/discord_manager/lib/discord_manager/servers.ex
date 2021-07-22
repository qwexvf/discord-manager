defmodule DiscordManager.Servers do
  @moduledoc """
  The Servers context.
  """

  import Ecto.Query, warn: false
  alias DiscordManager.Repo

  alias DiscordManager.Servers.Schedule
  alias DiscordManager.Workers.ScheduleWorker

  @doc """
  Returns the list of schedules.

  ## Examples

      iex> list_schedules()
      [%Schedule{}, ...]

  """
  def list_schedules(user_id) do
    Schedule
    |> where([s], s.user_id == ^user_id)
    |> preload([:user, :job])
    |> Repo.all()
  end

  def run_all do
    Oban.drain_queue(queue: :special)
  end

  @doc """
  Gets a single schedule.

  Raises `Ecto.NoResultsError` if the Schedule does not exist.

  ## Examples

      iex> get_schedule!(123)
      %Schedule{}

      iex> get_schedule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_schedule!(id, user_id) do
    Schedule
    |> where([s], s.user_id == ^user_id)
    |> where([s], s.id == ^id)
    |> preload([:user, :job])
    |> Repo.one()
  end

  @doc """
  Creates a schedule.

  ## Examples

      iex> create_schedule(%{field: value})
      {:ok, %Schedule{}}

      iex> create_schedule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_schedule(user_id, attrs \\ %{}) do
    %{}
    |> ScheduleWorker.new(queue: :special, max_attempts: 5, schedule_in: 10)
    |> Oban.insert()
    |> case do
      {:error, _changeset} ->
        :noop
      {:ok, job} ->
        %Schedule{user_id: user_id, job_id: job.id}
        |> Schedule.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Updates a schedule.

  ## Examples

      iex> update_schedule(schedule, %{field: new_value})
      {:ok, %Schedule{}}

      iex> update_schedule(schedule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_schedule(%Schedule{} = schedule, user_id, attrs) do
    schedule
    |> Schedule.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a schedule.

  ## Examples

      iex> delete_schedule(schedule)
      {:ok, %Schedule{}}

      iex> delete_schedule(schedule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_schedule(%Schedule{} = schedule) do
    Repo.delete(schedule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking schedule changes.

  ## Examples

      iex> change_schedule(schedule)
      %Ecto.Changeset{data: %Schedule{}}

  """
  def change_schedule(%Schedule{} = schedule, attrs \\ %{}) do
    Schedule.changeset(schedule, attrs)
  end
end

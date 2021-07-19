defmodule DiscordManager.Repo.Migrations.CreateSchedules do
  use Ecto.Migration

  def change do
    create table(:schedules) do
      add :message, :string
      add :uuid, :string
      add :job_id, references(:oban_jobs, on_delete: :nothing)

      timestamps()
    end

    create index(:schedules, [:job_id])
  end
end

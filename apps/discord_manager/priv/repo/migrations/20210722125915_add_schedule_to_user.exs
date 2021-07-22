defmodule DiscordManager.Repo.Migrations.AddScheduleToUser do
  use Ecto.Migration

  def up do
    alter table(:schedules) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:schedules, [:user_id])
  end
end

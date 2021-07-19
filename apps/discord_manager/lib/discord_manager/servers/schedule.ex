defmodule DiscordManager.Servers.Schedule do
  use Ecto.Schema
  import Ecto.Changeset


  schema "schedules" do
    field :message, :string
    field :uuid, :string
    belongs_to :job, Oban.Job

    timestamps()
  end

  @doc false
  def changeset(schedule, attrs) do
    schedule
    |> cast(attrs, [:message, :uuid, :job_id])
    |> validate_required([:message, :uuid, :job_id])
  end
end

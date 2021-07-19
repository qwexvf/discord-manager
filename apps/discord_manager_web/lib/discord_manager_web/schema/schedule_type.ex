defmodule DiscordManagerWeb.Schema.ScheduleType do
  @moduledoc false
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload
  alias DiscordManagerWeb.Resolvers

  object :schedule_type do
    field :id, :integer
    field :message, :string
    field :uuid, :string
    field :job, :job_type
  end

  object :job_type do
    field :id, :integer
    field :state, :string
  end

  payload_object(:schedule_payload, :schedule_type)

  object :schedule_queries do
    @desc "Get or refresh a jwt token"
    field :schedules, type: list_of(:schedule_type) do
      resolve &Resolvers.ScheduleResolver.list/3
    end
  end

  object :schedule_mutations do
    @desc "Get or refresh a jwt token"
    field :run_all, type: :boolean do
      resolve &Resolvers.ScheduleResolver.run_all/3
    end
  end
end

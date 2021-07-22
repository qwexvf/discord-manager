defmodule DiscordManagerWeb.Schema.ScheduleType do
  @moduledoc false
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload
  alias DiscordManagerWeb.Resolvers
  alias DiscordManagerWeb.Middlewares.Authentication

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

  input_object :update_schedule do
    field :schedule_id, :integer
    field :message, :string
  end

  input_object :create_schedule do
    field :message, :string
  end

  object :schedule_queries do
    @desc "Get or refresh a jwt token"
    field :schedules, type: list_of(:schedule_type) do
      middleware Authentication
      resolve &Resolvers.ScheduleResolver.list/3
    end
  end

  object :schedule_mutations do
    @desc "Run a specific schedule"
    field :run_all, type: :boolean do
      middleware Authentication
      resolve &Resolvers.ScheduleResolver.run_all/3
    end

    @desc "Create Schedule"
    field :create_schedule, type: :schedule_payload do
      arg :attrs, :create_schedule
      middleware Authentication
      resolve &Resolvers.ScheduleResolver.create_schedule/3
      middleware &build_payload/2
    end

    @desc "Update Schedule"
    field :update_schedule, type: :schedule_payload do
      arg :attrs, :update_schedule
      middleware Authentication
      resolve &Resolvers.ScheduleResolver.update_schedule/3
      middleware &build_payload/2
    end

    @desc "Delete Schedule"
    field :delete_schedule, type: :boolean do
      middleware Authentication
      resolve &Resolvers.ScheduleResolver.delete_schedule/3
    end
  end

  object :scheduler_subscriptions do

    @desc "Subscribe to schedule list"
    field :schedule_list, :schedule_type do
      config fn _args, %{context: context} ->
        IO.inspect context
        {:ok, topic: context.user_id}
      end

      trigger :update_schedule, topic: fn schedule ->
        IO.inspect schedule
        schedule.result.user.id
      end

      resolve fn comment, _, _ ->
        {:ok, comment.result}
      end
    end
  end
end

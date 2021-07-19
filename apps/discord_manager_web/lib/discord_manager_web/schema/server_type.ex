defmodule DiscordManagerWeb.Schema.ServerType do
  @moduledoc false
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload

  object :server_type do
    field :id, :id
    field :email, :string
  end

  payload_object(:server_payload, :server_type)

  input_object :server_update_input do
    field :email, :string
    field :password, :string
  end

  object :server_queries do
    @desc "List server"
    field :list_server, type: :server_payload do
      arg :id, non_null(:integer)
      arg :params, :server_update_input
    end
  end
end

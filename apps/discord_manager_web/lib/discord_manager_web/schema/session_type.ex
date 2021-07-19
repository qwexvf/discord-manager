defmodule DiscordManagerWeb.Schema.SessionType do
  @moduledoc false
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload
  alias DiscordManagerWeb.Resolvers

  object :session_type do
    field :token, :string
    field :user, :user_type
  end

  payload_object(:session_payload, :session_type)

  object :session_mutations do
    @desc "Get or refresh a jwt token"
    field :authenticate, type: :session_payload do
      arg :email, non_null :string
      arg :password, non_null :string
      arg :password_confirm, non_null :string
      resolve &Resolvers.SessionResolver.register/3
      middleware &build_payload/2
    end
  end
end

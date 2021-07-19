defmodule DiscordManagerWeb.Schema.UserType do
  @moduledoc false
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload
  alias DiscordManagerWeb.Resolvers

  object :user_type do
    field :id, :id
    field :email, :string
  end

  payload_object(:user_payload, :user_type)

  input_object :user_update_input do
    field :email, :string
    field :password, :string
  end

  object :user_mutations do
    @desc "Update User"
    field :update_user, type: :user_payload do
      arg :id, non_null(:integer)
      arg :params, :user_update_input
      resolve &Resolvers.UserResolver.update/3
    end
  end
end

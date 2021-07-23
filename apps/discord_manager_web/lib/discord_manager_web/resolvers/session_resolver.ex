defmodule DiscordManagerWeb.Resolvers.SessionResolver do
  alias DiscordManager.{Accounts, Guardian}

  def login(_, input, _) do
    IO.inspect Accounts.sign_in(input)
    with {:ok, user} <- Accounts.sign_in(input),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: token, user: user}}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, changeset}
      {:error, message} ->
        {:ok, %AbsintheErrorPayload.ValidationMessage{
          code: "asdf",
          message: message,
        }}
    end
  end

  def register(_, input, _) do
    with {:ok, user} <- Accounts.create_user(input),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: token, user: user}}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, changeset}
    end
  end
end

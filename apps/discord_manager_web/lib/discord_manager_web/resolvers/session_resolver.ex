defmodule DiscordManagerWeb.Resolvers.SessionResolver do
  alias DiscordManager.{Accounts, Guardian}

  def login(_, input, _) do
    with {:ok, user} <- Accounts.sign_in(input),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: token, user: user}}
    else
      {:error, changeset} ->
        {:ok, changeset}
    end
  end

  def register(_, input, _) do
    with {:ok, user} <- Accounts.create_user(input),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: token, user: user}}
    else
      {:error, changeset} ->
        {:ok, changeset}
    end
  end
end

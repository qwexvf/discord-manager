defmodule DiscordManagerWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket,
    schema: DiscordManagerWeb.Schema
  alias DiscordManager.Guardian

  ## Channels
  # channel "room:*", DiscordManagerWeb.RoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl true
  def connect(%{"Authorization" => header_content}, socket) do
    [[_, token]] = Regex.scan(~r/^Bearer (.*)/, header_content)

    with {:ok, _claims} <- Guardian.decode_and_verify(token),
         {:ok, user, _claims} <- Guardian.resource_from_token(token) do
      new_socket = assign(socket, :user_id, user.id)

      new_socket =
        Absinthe.Phoenix.Socket.put_options(new_socket,
          context: %{
            user_id: user.id
          }
        )
      {:ok, new_socket}
    else
      {:error, _} ->
        :error
    end
  end

  # This function will be called when there was no authentication information
  def connect(_params, _socket) do
    :error
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     DiscordManagerWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(socket), do: "user_socket:#{socket.assigns.user_id}"
end

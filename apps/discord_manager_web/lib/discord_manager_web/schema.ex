defmodule DiscordManagerWeb.Schema do
  use Absinthe.Schema

  alias DiscordManagerWeb.Data

  import_types Absinthe.Type.Custom
  import_types DiscordManagerWeb.Schema.Types
  import_types AbsintheErrorPayload.ValidationMessageTypes

  query do
    import_fields :schedule_queries
    import_fields :server_queries
  end

  mutation do
    import_fields :session_mutations
    import_fields :schedule_mutations
  end

  subscription do
    import_fields :scheduler_subscriptions
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Data, Data.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _field, _object) do
    [] ++ middleware
  end
end

defmodule DiscordManagerWeb.Router do
  use DiscordManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"] # plug DiscordManagerWeb.Plugs.Context
    plug DiscordManagerWeb.Plugs.Context
  end

  scope "/graphql" do
    pipe_through [:api]
    forward "/", Absinthe.Plug,
      schema: DiscordManagerWeb.Schema,
      socket: DiscordManagerWeb.UserSocket
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/graphiql" do
      forward "/", Absinthe.Plug.GraphiQL,
      schema: DiscordManagerWeb.Schema,
      socket: DiscordManagerWeb.UserSocket
    end

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: DiscordManagerWeb.Telemetry
    end
  end
end

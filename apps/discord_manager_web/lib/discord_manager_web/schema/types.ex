defmodule DiscordManagerWeb.Schema.Types do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias DiscordManagerWeb.Schema.{
    UserType,
    ServerType,
    SessionType,
    ScheduleType,
  }

  import_types UserType
  import_types ServerType
  import_types SessionType
  import_types ScheduleType
end

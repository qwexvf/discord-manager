defmodule DiscordManager.ServersTest do
  use DiscordManager.DataCase

  alias DiscordManager.Servers

  describe "schedules" do
    alias DiscordManager.Servers.Schedule

    @valid_attrs %{jon_id: "some jon_id", message: "some message", uuid: "some uuid"}
    @update_attrs %{jon_id: "some updated jon_id", message: "some updated message", uuid: "some updated uuid"}
    @invalid_attrs %{jon_id: nil, message: nil, uuid: nil}

    def schedule_fixture(attrs \\ %{}) do
      {:ok, schedule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Servers.create_schedule()

      schedule
    end

    test "list_schedules/0 returns all schedules" do
      schedule = schedule_fixture()
      assert Servers.list_schedules() == [schedule]
    end

    test "get_schedule!/1 returns the schedule with given id" do
      schedule = schedule_fixture()
      assert Servers.get_schedule!(schedule.id) == schedule
    end

    test "create_schedule/1 with valid data creates a schedule" do
      assert {:ok, %Schedule{} = schedule} = Servers.create_schedule(@valid_attrs)
      assert schedule.jon_id == "some jon_id"
      assert schedule.message == "some message"
      assert schedule.uuid == "some uuid"
    end

    test "create_schedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Servers.create_schedule(@invalid_attrs)
    end

    test "update_schedule/2 with valid data updates the schedule" do
      schedule = schedule_fixture()
      assert {:ok, %Schedule{} = schedule} = Servers.update_schedule(schedule, @update_attrs)
      assert schedule.jon_id == "some updated jon_id"
      assert schedule.message == "some updated message"
      assert schedule.uuid == "some updated uuid"
    end

    test "update_schedule/2 with invalid data returns error changeset" do
      schedule = schedule_fixture()
      assert {:error, %Ecto.Changeset{}} = Servers.update_schedule(schedule, @invalid_attrs)
      assert schedule == Servers.get_schedule!(schedule.id)
    end

    test "delete_schedule/1 deletes the schedule" do
      schedule = schedule_fixture()
      assert {:ok, %Schedule{}} = Servers.delete_schedule(schedule)
      assert_raise Ecto.NoResultsError, fn -> Servers.get_schedule!(schedule.id) end
    end

    test "change_schedule/1 returns a schedule changeset" do
      schedule = schedule_fixture()
      assert %Ecto.Changeset{} = Servers.change_schedule(schedule)
    end
  end
end

defmodule Theme01.AgendaTest do
  use Theme01.DataCase

  alias Theme01.Agenda

  describe "workingtimes" do
    alias Theme01.Agenda.WorkingTime

    import Theme01.AgendaFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      working_time = working_time_fixture()
      assert Agenda.list_workingtimes() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Agenda.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{end: ~N[2021-10-25 09:35:00], start: ~N[2021-10-25 09:35:00]}

      assert {:ok, %WorkingTime{} = working_time} = Agenda.create_working_time(valid_attrs)
      assert working_time.end == ~N[2021-10-25 09:35:00]
      assert working_time.start == ~N[2021-10-25 09:35:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Agenda.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{end: ~N[2021-10-26 09:35:00], start: ~N[2021-10-26 09:35:00]}

      assert {:ok, %WorkingTime{} = working_time} = Agenda.update_working_time(working_time, update_attrs)
      assert working_time.end == ~N[2021-10-26 09:35:00]
      assert working_time.start == ~N[2021-10-26 09:35:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Agenda.update_working_time(working_time, @invalid_attrs)
      assert working_time == Agenda.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Agenda.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Agenda.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Agenda.change_working_time(working_time)
    end
  end
end

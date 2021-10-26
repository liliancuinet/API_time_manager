defmodule Theme01.AgendaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Theme01.Agenda` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2021-10-25 09:35:00],
        start: ~N[2021-10-25 09:35:00]
      })
      |> Theme01.Agenda.create_working_time()

    working_time
  end
end

defmodule Theme01.HorlogeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Theme01.Horloge` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2021-10-25 09:34:00]
      })
      |> Theme01.Horloge.create_clock()

    clock
  end
end

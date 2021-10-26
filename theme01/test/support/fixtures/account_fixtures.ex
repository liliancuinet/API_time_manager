defmodule Theme01.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Theme01.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> Theme01.Account.create_user()

    user
  end
end

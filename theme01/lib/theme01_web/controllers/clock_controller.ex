defmodule Theme01Web.ClockController do
  use Theme01Web, :controller

  alias Theme01.Horloge
  alias Theme01.Horloge.Clock

  action_fallback Theme01Web.FallbackController

  def index(conn, %{"userID" => user}) do
    clocks = Horloge.list_clocks(user)
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"userID" => user, "clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Horloge.create_clock(user, clock_params) do
      conn
      |> put_status(:created)
      |> render("show.json", clock: clock)
    end
  end
end

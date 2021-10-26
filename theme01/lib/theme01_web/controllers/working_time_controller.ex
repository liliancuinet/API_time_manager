defmodule Theme01Web.WorkingTimeController do
  use Theme01Web, :controller

  alias Theme01.Agenda
  alias Theme01.Agenda.WorkingTime

  action_fallback Theme01Web.FallbackController

  def index(conn, %{"userID" => user}) do
    workingtimes = Agenda.list_workingtimes(user)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"userID" => user, "working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Agenda.create_working_time(user, working_time_params) do
      conn
      |> put_status(:created)
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"userID" => user, "id" => id}) do
    working_time = Agenda.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Agenda.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Agenda.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Agenda.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Agenda.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule Theme01Web.WorkingTimeController do
  use Theme01Web, :controller

  alias Theme01.Agenda
  alias Theme01.Agenda.WorkingTime

  action_fallback Theme01Web.FallbackController

  def index(conn, params) do
    token = get_req_header(conn, "authorization")
    if token == [] do
      conn
      |> put_status(:unauthorized)
      |> put_view(Theme01Web.ErrorView)
      |> render(:"401")
    else
      try do
        claims = Theme01.Token.verify_and_validate!(List.last(token))
        {userID, ""} = Integer.parse(params["userID"])
        if claims["user_role"] == "user" && claims["user_id"] != userID do
          conn
          |> put_status(:unauthorized)
          |> put_view(Theme01Web.ErrorView)
          |> render(:"401")
        else
          workingtimes = Agenda.list_workingtimes(params)
          render(conn, "index.json", workingtimes: workingtimes)
        end
      rescue
        Joken.Error -> conn
                        |> put_status(:unauthorized)
                        |> put_view(Theme01Web.ErrorView)
                        |> render(:"401")
      end
    end
  end

  def create(conn, %{"userID" => user, "working_time" => working_time_params}) do
    token = get_req_header(conn, "authorization")
    if token == [] do
      conn
      |> put_status(:unauthorized)
      |> put_view(Theme01Web.ErrorView)
      |> render(:"401")
    else
      try do
        claims = Theme01.Token.verify_and_validate!(List.last(token))
        if claims["user_role"] == "user" do
          conn
          |> put_status(:unauthorized)
          |> put_view(Theme01Web.ErrorView)
          |> render(:"401")
        else
          with {:ok, %WorkingTime{} = working_time} <- Agenda.create_working_time(user, working_time_params) do
            conn
            |> put_status(:created)
            |> render("show.json", working_time: working_time)
          end
        end
      rescue
        Joken.Error -> conn
                        |> put_status(:unauthorized)
                        |> put_view(Theme01Web.ErrorView)
                        |> render(:"401")
      end
    end
  end

  def show(conn, %{"userID" => user, "id" => id}) do
    token = get_req_header(conn, "authorization")
    if token == [] do
      conn
      |> put_status(:unauthorized)
      |> put_view(Theme01Web.ErrorView)
      |> render(:"401")
    else
      try do
        claims = Theme01.Token.verify_and_validate!(List.last(token))
        {userID, ""} = Integer.parse(user)
        if claims["user_role"] == "user" && claims["user_id"] != userID do
          conn
          |> put_status(:unauthorized)
          |> put_view(Theme01Web.ErrorView)
          |> render(:"401")
        else
          working_time = Agenda.get_working_time!(id)
          render(conn, "show.json", working_time: working_time)
        end
      rescue
        Joken.Error -> conn
                        |> put_status(:unauthorized)
                        |> put_view(Theme01Web.ErrorView)
                        |> render(:"401")
      end
    end
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    token = get_req_header(conn, "authorization")
    if token == [] do
      conn
      |> put_status(:unauthorized)
      |> put_view(Theme01Web.ErrorView)
      |> render(:"401")
    else
      try do
        claims = Theme01.Token.verify_and_validate!(List.last(token))
        if claims["user_role"] == "user"do
          conn
          |> put_status(:unauthorized)
          |> put_view(Theme01Web.ErrorView)
          |> render(:"401")
        else
          working_time = Agenda.get_working_time!(id)
          with {:ok, %WorkingTime{} = working_time} <- Agenda.update_working_time(working_time, working_time_params) do
            render(conn, "show.json", working_time: working_time)
          end
        end
      rescue
        Joken.Error -> conn
                        |> put_status(:unauthorized)
                        |> put_view(Theme01Web.ErrorView)
                        |> render(:"401")
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    token = get_req_header(conn, "authorization")
    if token == [] do
      conn
      |> put_status(:unauthorized)
      |> put_view(Theme01Web.ErrorView)
      |> render(:"401")
    else
      try do
        claims = Theme01.Token.verify_and_validate!(List.last(token))
        if claims["user_role"] == "user" do
          conn
          |> put_status(:unauthorized)
          |> put_view(Theme01Web.ErrorView)
          |> render(:"401")
        else
          working_time = Agenda.get_working_time!(id)
          with {:ok, %WorkingTime{}} <- Agenda.delete_working_time(working_time) do
            send_resp(conn, :no_content, "")
          end
        end
      rescue
        Joken.Error -> conn
                        |> put_status(:unauthorized)
                        |> put_view(Theme01Web.ErrorView)
                        |> render(:"401")
      end
    end
  end
end

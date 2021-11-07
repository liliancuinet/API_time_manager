defmodule Theme01Web.ClockController do
  use Theme01Web, :controller

  alias Theme01.Horloge
  alias Theme01.Horloge.Clock

  action_fallback Theme01Web.FallbackController

  def index(conn, %{"userID" => user}) do
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
          clocks = Horloge.list_clocks(user)
          render(conn, "index.json", clocks: clocks)
        end
      rescue
        Joken.Error -> conn
                        |> put_status(:unauthorized)
                        |> put_view(Theme01Web.ErrorView)
                        |> render(:"401")
      end
    end
  end

  def create(conn, %{"userID" => user, "clock" => clock_params}) do
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
          with {:ok, %Clock{} = clock} <- Horloge.create_clock(user, clock_params) do
            conn
            |> put_status(:created)
            |> render("show.json", clock: clock)
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
        if claims["user_role"] == "user"do
          conn
          |> put_status(:unauthorized)
          |> put_view(Theme01Web.ErrorView)
          |> render(:"401")
        else
          clock = Horloge.get_clock!(id)
          with {:ok, %Clock{}} <- Horloge.delete_clock(clock) do
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

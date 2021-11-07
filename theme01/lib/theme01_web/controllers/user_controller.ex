defmodule Theme01Web.UserController do
  use Theme01Web, :controller
  require Logger
  alias Theme01.Account
  alias Theme01.Account.User

  action_fallback Theme01Web.FallbackController

  def index(conn, _params) do
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
          users = Account.list_users()
          render(conn, "index.json", users: users)
        end
      rescue
        Joken.Error -> conn
                        |> put_status(:unauthorized)
                        |> put_view(Theme01Web.ErrorView)
                        |> render(:"401")
      end
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"userID" => id}) do
    token = get_req_header(conn, "authorization")
    if token == [] do
      conn
      |> put_status(:unauthorized)
      |> put_view(Theme01Web.ErrorView)
      |> render(:"401")
    else
      try do
        claims = Theme01.Token.verify_and_validate!(List.last(token))
        {userID, ""} = Integer.parse(id)
        if claims["user_role"] == "user" && claims["user_id"] != userID do
          conn
          |> put_status(:unauthorized)
          |> put_view(Theme01Web.ErrorView)
          |> render(:"401")
        end
      rescue
        Joken.Error -> conn
                        |> put_status(:unauthorized)
                        |> put_view(Theme01Web.ErrorView)
                        |> render(:"401")
      end
      user = Account.get_user!(id)
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    token = get_req_header(conn, "authorization")
    if token == [] do
      conn
      |> put_status(:unauthorized)
      |> put_view(Theme01Web.ErrorView)
      |> render(:"401")
    else
      try do
        claims = Theme01.Token.verify_and_validate!(List.last(token))
        {userID, ""} = Integer.parse(id)
        if claims["user_role"] == "user" && claims["user_id"] != userID do
          conn
          |> put_status(:unauthorized)
          |> put_view(Theme01Web.ErrorView)
          |> render(:"401")
        end
      rescue
        Joken.Error -> conn
                        |> put_status(:unauthorized)
                        |> put_view(Theme01Web.ErrorView)
                        |> render(:"401")
      end
      user = Account.get_user!(id)
      with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
        render(conn, "show.json", user: user)
      end
    end
  end

  def delete(conn, %{"userID" => id}) do
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
          user = Account.get_user!(id)
          with {:ok, %User{}} <- Account.delete_user(user) do
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

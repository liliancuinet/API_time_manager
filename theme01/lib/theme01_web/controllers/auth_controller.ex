defmodule Theme01Web.AuthController do
  use Theme01Web, :controller

  alias Theme01.Account
  action_fallback Theme01Web.FallbackController

  def login(conn, %{"email" => email, "password" => password}) do
    user = Account.find_user(email, password)
    if user == [] do
      conn
      |> put_status(:unauthorized)
      |> put_view(Theme01Web.ErrorView)
      |> render(:"401")
    else
      user_item = List.last(user)
      extra_claims = %{"user_id" => user_item.id, "user_role" => user_item.role}
      token = Theme01.Token.generate_and_sign!(extra_claims)
      render(conn, "token.json", token: token, user: user_item)
    end
  end
end

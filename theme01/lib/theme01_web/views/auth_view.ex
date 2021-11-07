defmodule Theme01Web.AuthView do
  require Logger
  use Theme01Web, :view
  alias Theme01Web.AuthView

  def render("token.json", %{token: token, user: user}) do
    %{
      token: token,
      user_id: user.id,
      user_role: user.role
    }
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, AuthView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, AuthView, "user.json")}
  end

  def render("user.json", %{auth: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role
    }
  end
end

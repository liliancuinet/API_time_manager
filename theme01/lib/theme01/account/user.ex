defmodule Theme01.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string
    field :role, :string
    has_many :clock, Theme01.Horloge.Clock
    has_many :workingtimes, Theme01.Agenda.WorkingTime

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role])
    |> validate_required([:username, :email, :password, :role])
  end
end

defmodule Theme01.Repo.Migrations.AddRoleAndPasswordToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :password, :string # Database type
      add :role,  :string  # Elixir type which is handled by the database
    end
  end
end

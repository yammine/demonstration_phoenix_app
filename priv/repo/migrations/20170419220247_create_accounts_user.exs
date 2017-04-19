defmodule Example.Repo.Migrations.CreateExample.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :email, :string

      timestamps()
    end

    create unique_index(:accounts_users, [:email])
  end
end

defmodule Example.Repo.Migrations.CreateExample.Accounts.Potato do
  use Ecto.Migration

  def change do
    create table(:accounts_potatoes) do
      add :type, :string, null: false
      add :user_id, references(:accounts_users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:accounts_potatoes, [:user_id])
  end
end

defmodule Example.Accounts.User do
  use Ecto.Schema

  alias Example.Accounts.Potato

  schema "accounts_users" do
    field :email, :string
    has_one :potato, Potato

    timestamps()
  end
end

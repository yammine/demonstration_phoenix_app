defmodule Example.Accounts.Potato do
  use Ecto.Schema
  alias Example.Accounts.User

  schema "accounts_potatoes" do
    field :type, :string
    belongs_to :user, User

    timestamps()
  end
end

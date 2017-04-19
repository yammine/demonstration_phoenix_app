defmodule Example.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Example.Repo

  alias Example.Accounts.{User, Potato}

  @doc """
  Get a Potato
  """
  def get_potato!(id, opts \\ []) do
    base_query = from p in Potato,
      where: p.id == ^id
    query = build_potato_query(opts, base_query)

    Repo.one!(query)
  end

  defp build_potato_query([], query), do: query
  # Currently only supporting one option, but this is a demonstration on how you can compose many queries with ecto
  defp build_potato_query([{:preload_user, true}|tail], query) do
    new_query = from p in query,
      preload: [:user]

    build_potato_query(tail, new_query)
  end

  @doc """
  Create a Potato and associate it with an existing user
  """
  def create_potato(user_struct_or_id, attrs \\ %{})
  def create_potato(user_id, attrs) when is_integer(user_id) do
    get_user!(user_id)
    |> create_potato(attrs)
  end
  def create_potato(%User{} = user, attrs) do
    Ecto.build_assoc(user, :potato)
    |> potato_changeset(attrs)
    |> Repo.insert()
  end

  defp potato_changeset(%Potato{} = potato, attrs) do
    potato
    |> cast(attrs, [:type])
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> user_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
end

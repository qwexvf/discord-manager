defmodule DiscordManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :encrpyted_password, :string
    field :password, :string, virtual: true
    field :password_hash, :string, virtual: true
    field :name, :string

    has_many :schedules, DiscordManager.Servers.Schedule

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :encrpyted_password, :email])
    |> validate_required([:name, :encrpyted_password, :email])
  end

  @doc false
  def create_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:password, :email])
    |> validate_required([:password, :email])
    |> unique_email()
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, encrpyted_password: Argon2.hash_pwd_salt(password))
  end
  defp put_pass_hash(changeset), do: changeset

  defp unique_email(changeset) do
    changeset
    |> validate_format(
      :email,
      ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-\.]+\.[a-zA-Z]{2,}$/
    )
    |> validate_length(:email, max: 255)
    |> unique_constraint(:email)
  end
end

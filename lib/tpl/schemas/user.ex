defmodule Tpl.User do
  use Ecto.Schema
  use Arc.Ecto.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    field :current_password, :string, virtual: true
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :avatar, Tpl.User.Avatar.Type

    timestamps()
  end
end

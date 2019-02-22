defmodule Tpl.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :encrypted_password, :string, null: false
      add :avatar, :string

      timestamps()
    end

    execute "CREATE UNIQUE INDEX users_name_index ON users (LOWER(name))"
    execute "CREATE UNIQUE INDEX users_email_index ON users (LOWER(email))"
  end

  def down do
    drop table(:users)
  end
end

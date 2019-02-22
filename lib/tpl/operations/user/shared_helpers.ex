defmodule Tpl.User.SharedHelpers do
  import Ecto.Changeset
  use Arc.Ecto.Schema

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :current_password, :password])
    |> cast_attachments(attrs, [:avatar])
    |> validate_required([:name, :email])
    |> validate_password_presence()
    |> check_current_password()
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:name, name: :users_name_index)
    |> unique_constraint(:email, name: :users_email_index)
    |> downcase_email()
    |> encrypt_password()
  end

  defp validate_password_presence(changeset) do
    if changeset.data.encrypted_password do
      changeset
    else
      changeset |> validate_required([:password])
    end
  end

  defp check_current_password(%Ecto.Changeset{data: %{id: nil}} = changeset) do
    changeset
  end

  defp check_current_password(%Ecto.Changeset{changes: %{password: _}} = changeset) do
    changeset = changeset |> validate_required([:current_password])

    with %Ecto.Changeset{valid?: true, changes: %{current_password: current_pass}} <- changeset,
         true <- Bcrypt.verify_pass(current_pass, changeset.data.encrypted_password) do
      changeset
    else
      _ -> changeset |> add_error(:current_password, "Неверный текущий пароль")
    end
  end

  defp check_current_password(changeset) do
    changeset
  end

  defp downcase_email(changeset) do
    changeset |> update_change(:email, &String.downcase/1)
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        changeset |> put_change(:encrypted_password, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end

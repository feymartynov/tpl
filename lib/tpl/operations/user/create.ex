defmodule Tpl.User.Create do
  use Tpl.Operation, params: %{user: %{name!: :string, email!: :string, password!: :string}}
  alias Tpl.{Repo, User}

  def call(operation) do
    operation
    |> step(:create_user, fn _ -> create_user(operation.params.user) end)
  end

  defp create_user(params) do
    %User{}
    |> User.SharedHelpers.changeset(params)
    |> Repo.insert()
  end
end

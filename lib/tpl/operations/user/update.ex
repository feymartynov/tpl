defmodule Tpl.User.Update do
  use Tpl.Operation,
    params: %{
      user: %{
        name: :string,
        email: :string,
        current_password: :string,
        password: :string,
        avatar: :map
      }
    }

  alias Tpl.{Repo, User}

  def call(operation) do
    operation
    |> step(:update_user, fn _ -> update_user(operation.context.user, operation.params.user) end)
  end

  defp update_user(user, params) do
    user
    |> User.SharedHelpers.changeset(params)
    |> Repo.update()
  end
end

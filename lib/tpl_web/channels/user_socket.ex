defmodule TplWeb.UserSocket do
  use Phoenix.Socket
  alias Tpl.{Repo, User}

  def connect(params, socket) do
    with %{"token" => token} <- params,
         {:ok, user_id} <- Phoenix.Token.verify(socket, "ws_token", token, max_age: 86_400),
         %User{} = user <- User |> Repo.get(user_id) do
      {:ok, socket |> assign(:current_user, user)}
    else
      _ -> :error
    end
  end

  def id(socket), do: "user_socket:#{socket.assigns.current_user.id}"
end

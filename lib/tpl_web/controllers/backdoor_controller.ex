defmodule TplWeb.BackdoorController do
  use Phoenix.Controller

  def show(conn, %{"id" => user_id}) do
    if Mix.env() in [:dev, :test] do
      conn |> put_session(:current_user_id, String.to_integer(user_id)) |> redirect(to: "/")
    else
      {:error, :not_found}
    end
  end
end

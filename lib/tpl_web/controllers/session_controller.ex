defmodule TplWeb.SessionController do
  use TplWeb, :controller
  alias Tpl.{Repo, User}

  def new(conn, _params) do
    conn |> render()
  end

  plug :scrub_params, "session" when action == :create

  def create(conn, %{"session" => params}) do
    with true <- is_bitstring(params["email"]),
         true <- is_bitstring(params["password"]),
         %User{} = user <- User |> Repo.get_by(email: String.downcase(params["email"])),
         true <- Bcrypt.verify_pass(params["password"], user.encrypted_password) do
      conn
      |> put_session(:current_user_id, user.id)
      |> redirect(to: Routes.home_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, gettext("Wrong email or password."))
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn |> put_flash(:info, gettext("Goodbye!")) |> redirect(to: Routes.session_path(conn, :new))
  end
end

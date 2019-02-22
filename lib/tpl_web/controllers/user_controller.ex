defmodule TplWeb.UserController do
  use TplWeb, :controller
  alias Tpl.User

  plug :scrub_params, "user" when action in [:create, :update]

  def new(conn, params) do
    changeset = %User{} |> User.SharedHelpers.changeset(params["user"] || %{})
    conn |> render(changeset: changeset)
  end

  def create(conn, params) do
    case User.Create |> run(conn, params) do
      {:ok, %{create_user: user}} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, gettext("You have successfully signed up!"))
        |> redirect(to: "/")

      {:error, _, %Ecto.Changeset{} = changeset, _} ->
        conn
        |> put_flash(:error, gettext("Wrong form values given."))
        |> render(:new, changeset: changeset)
    end
  end

  def edit(conn, params) do
    user = conn.assigns.current_user
    changeset = user |> User.SharedHelpers.changeset(params["user"] || %{})
    conn |> render(user: user, changeset: changeset)
  end

  def update(conn, params) do
    case User.Update |> run(conn, params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext("Changes saved."))
        |> redirect(to: Routes.user_path(conn, :edit))

      {:error, _, %Ecto.Changeset{} = changeset, _} ->
        conn
        |> put_flash(:error, gettext("Wrong form values given."))
        |> render(:edit, changeset: changeset)
    end
  end
end

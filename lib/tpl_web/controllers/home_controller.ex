defmodule TplWeb.HomeController do
  use TplWeb, :controller

  def index(conn, _params) do
    conn |> render()
  end
end

defmodule TplWeb.LayoutView do
  use TplWeb, :view

  def ws_token(conn) do
    case conn.assigns[:current_user] do
      %Tpl.User{id: user_id} -> Phoenix.Token.sign(conn, "ws_token", user_id)
      nil -> nil
    end
  end

  def alert(conn, type) do
    case get_flash(conn, type) do
      nil ->
        nil

      message ->
        css_class = (type == :error && "alert-danger") || "alert-info"

        content_tag(:p, class: "alert #{css_class} alert-dismissible", role: "alert") do
          dismiss_button =
            content_tag(:button, type: "button", class: "close", data: [dismiss: "alert"]) do
              content_tag(:span, {:safe, "&times;"})
            end

          [message, dismiss_button]
        end
    end
  end
end

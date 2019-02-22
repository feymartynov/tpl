defmodule TplWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :tpl

  if Application.get_env(:tpl, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  socket "/socket", TplWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :tpl,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  plug Plug.Static, at: "/uploads", from: "uploads"

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_tpl_key",
    signing_salt: "r6/Ifpdi"

  plug TplWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      config =
        config
        |> Keyword.put(:http, [:inet6, port: get_env!("PORT")])
        |> Keyword.put(:secret_key_base, get_env!("SECRET_KEY_BASE"))

      {:ok, config}
    else
      {:ok, config}
    end
  end

  defp get_env!(env_var) do
    System.get_env(env_var) || raise "expected the #{env_var} environment variable to be set"
  end
end

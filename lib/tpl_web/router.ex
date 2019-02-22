defmodule TplWeb.Router do
  use TplWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authentication do
    plug TplWeb.Authenticate
  end

  # Public endpoints
  scope "/", TplWeb do
    pipe_through(:browser)

    get("/sign-in", SessionController, :new)
    post("/sign-in", SessionController, :create)

    get("/sign-up", UserController, :new)
    post("/sign-up", UserController, :create)

    # Backdoor for testing
    if Mix.env() in [:dev, :test] do
      get("/backdoor/:id", BackdoorController, :show)
    end
  end

  # Protected endpoints
  scope "/", TplWeb do
    pipe_through([:browser, :authentication])

    get("/profile", UserController, :edit)
    put("/profile", UserController, :update)
    post("/sign-out", SessionController, :delete)
    get("/", HomeController, :index)
  end
end

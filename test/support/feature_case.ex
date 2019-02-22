defmodule TplWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Tpl.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import TplWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tpl.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Tpl.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Tpl.Repo, self())

    {:ok, session} =
      Wallaby.start_session(metadata: metadata, window_size: [width: 1280, height: 720])

    {:ok, session: session}
  end
end

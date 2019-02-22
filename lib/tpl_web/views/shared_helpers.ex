defmodule TplWeb.SharedHelpers do
  def component(name, props \\ []) do
    props_json = props |> Map.new() |> Jason.encode!()
    Phoenix.HTML.Tag.tag(:span, data: [component: name, props: props_json])
  end

  def build_changeset(types, params \\ %{}) do
    {%{}, types} |> Ecto.Changeset.cast(params, Map.keys(types))
  end
end

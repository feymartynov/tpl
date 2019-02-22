defmodule Tpl.User.Avatar do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :big, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  def __storage, do: Arc.Storage.Local

  def acl(version, _) when version in [:big, :thumb], do: :public_read

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end

  def transform(:big, _) do
    {:convert, "-thumbnail 120x120^ -gravity center -extent 120x120 -format png", :png}
  end

  def transform(:thumb, _) do
    {:convert, "-thumbnail 40x40^ -gravity center -extent 40x40 -format png", :png}
  end

  def filename(version, _) do
    version
  end

  def storage_dir(_version, {_file, user}) do
    "uploads/avatars/#{user.id}"
  end

  def default_url(_) do
    "/images/default_avatar.png"
  end
end

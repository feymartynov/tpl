defmodule TplWeb.UserView do
  use TplWeb, :view

  def avatar_url(user, version \\ :thumb) do
    Tpl.User.Avatar.url({user.avatar, user}, version, signed: true)
  end
end

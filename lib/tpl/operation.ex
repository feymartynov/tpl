defmodule Tpl.Operation do
  defmacro __using__(opts) do
    quote do
      use ExOperation.Operation, unquote(opts)
      import Tpl.Operation
    end
  end
end

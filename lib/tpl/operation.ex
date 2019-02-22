defmodule Tpl.Operation do
  import ExOperation.DSL

  defmacro __using__(opts) do
    quote do
      use ExOperation.Operation, unquote(opts)
      import Tpl.Operation
    end
  end

  def authorize(operation, step_name, policy: policy, action: action) do
    step(operation, {:authorize, step_name}, fn txn ->
      case txn[step_name] do
        nil -> {:ok, :missing}
        entity -> do_authorize(policy, action, operation.context.current_user, entity)
      end
    end)
  end

  defp do_authorize(policy, action, user, entity) do
    case Bodyguard.permit(policy, action, user, entity) do
      :ok -> {:ok, :authorized}
      {:error, reason} -> {:error, reason}
    end
  end

  def publish(operation, topic, message) do
    step(operation, {:publish, make_ref()}, fn txn ->
      topic = if is_function(topic, 1), do: topic.(txn), else: topic
      message = if is_function(message, 1), do: message.(txn), else: topic
      Phoenix.PubSub.broadcast(Tpl.PubSub, topic, message)
    end)
  end
end

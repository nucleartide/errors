defmodule WrappedError do
  @behaviour Causer

  @enforce_keys[:error]
  defexception [:message, :env, :error]

  def cause(%WrappedError{error: error}) do
    error
  end
end

# defimpl Inspect, for: WrappedError do
# end

defimpl String.Chars, for: WrappedError do
  def to_string(%WrappedError{error: nil, message: msg}),
    do: msg
  def to_string(%WrappedError{error: err = %WrappedError{}, message: msg}),
    do: "#{msg}: #{err}"
  def to_string(%WrappedError{error: err, message: msg}),
    do: "#{msg}: #{Exception.message(err)}"
end

defimpl Inspect, for: WrappedError do
  # import Inspect.Algebra
  # message, env, error

  # base case
  defp inspects(err = %WrappedError{env: env, error: nil, message: msg}) do
    stacktrace = env
      |> Macro.Env.stacktrace()
      |> Exception.format_stacktrace()

    Exception.format_banner(:error, err, Macro.Env.stacktrace(env)) <> "\n" <> stacktrace
  end
  defp inspects(err = %WrappedError{env: env, error: new_err = %WrappedError{}, message: msg}) do
    stacktrace = env
      |> Macro.Env.stacktrace()
      |> Exception.format_stacktrace()

    Exception.format_banner(:error, err, Macro.Env.stacktrace(env)) <> "\n" <> stacktrace <> inspects(new_err)
  end
  defp inspects(current_err = %WrappedError{env: env, error: err, message: msg}) do
    stacktrace = env
      |> Macro.Env.stacktrace()
      |> Exception.format_stacktrace()

    Exception.format_banner(:error, current_err, Macro.Env.stacktrace(env)) <> "\n" <> stacktrace <> inspects(err)
  end
  # base case
  defp inspects(err) do
   Exception.format_banner(:error, err, [])
  end

  def inspect(err, _opts) do
    inspects(err)
  end
end

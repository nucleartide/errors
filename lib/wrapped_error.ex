defmodule WrappedError do
  @enforce_keys [:error]
  defexception [:message, :env, :error]
end

defimpl Unwrap, for: WrappedError do
  def unwrap(%WrappedError{error: e}), do: e
end

defimpl String.Chars, for: WrappedError do
  def to_string(%WrappedError{error: nil, message: msg}),
    do: msg
  def to_string(%WrappedError{error: err = %WrappedError{}, message: msg}),
    do: "#{msg}: #{err}"
  def to_string(%WrappedError{error: err, message: msg}),
    do: "#{msg}: #{Exception.message(err)}"
end

defimpl Inspect, for: WrappedError do
  def inspect(err, _opts) do
    document(err)
  end

  # Given a WrappedError, return an Inspect.Algebra document.
  defp document(w = %WrappedError{env: env, error: nil}) do
    :error
    |> Exception.format_banner(w, Macro.Env.stacktrace(env))
    |> Inspect.Algebra.line(stacktrace(env))
  end
  defp document(w = %WrappedError{env: env, error: err}) do
    :error
    |> Exception.format_banner(w, Macro.Env.stacktrace(env))
    |> Inspect.Algebra.line(stacktrace(env))
    |> Inspect.Algebra.line(document(err))
  end
  defp document(err) do
    Exception.format_banner(:error, err, [])
  end

  # Format a Macro.Env struct and return the formatting.
  defp stacktrace(env) do
    env
    |> Macro.Env.stacktrace()
    |> Exception.format_stacktrace()
    |> String.replace_suffix("\n", "")
  end
end

defmodule Errors do
  @doc """
  Wrap an error and message into a WrappedError.

  This macro automatically passes __ENV__ to the WrappedError. Thus, you
  should use this function over %WrappedError{} when possible.
  """
  @spec wrap(error :: String.t, message :: String.t) :: Macro.t
  defmacro wrap(error, message \\ "") do
    quote do
      WrappedError.exception(
        error:   unquote(error),
        env:     __ENV__,
        message: unquote(message)
      )
    end
  end

  @doc """
  Construct a new WrappedError.

  Note that the returned WrappedError will have its error field set to
  nil. If you want to _wrap_ an error, use Errors.wrap/2 instead.
  """
  @spec new(message :: String.t) :: Macro.t
  defmacro new(message \\ "") do
    quote do
      WrappedError.exception(env: __ENV__, message: unquote(message))
    end
  end

  @doc """
  Unwrap returns the original Exception of an Exception that implements
  the Unwrap behaviour.

      iex> RuntimeError.exception("something failed")
      ...> |> Errors.wrap()
      ...> |> Errors.unwrap()
      %RuntimeError{message: "something failed"}

  """
  @spec unwrap(error :: Unwrap.t) :: Exception.t
  def unwrap(error) do
    Unwrap.unwrap(error)
  end
end

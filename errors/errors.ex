defmodule Errors do
  @doc """
  Wrap an error and message into a WrappedError.

  This macro automatically passes __ENV__ to the WrappedError. Thus, you
  should use this function over %WrappedError{} when possible.
  """
  @spec wrap(error :: Exception.t, message :: String.t) :: Macro.t
  defmacro wrap(error, message \\ "") do
    quote do
      Errors.WrappedError.exception(
        error:   unquote(error),
        env:     __ENV__,
        message: unquote(message)
      )
    end
  end

  @doc """
  Construct a new WrappedError.

  Note that the returned WrappedError will have its error field set to
  nil. If you want to wrap an existing error, use Errors.wrap/2.
  """
  @spec new(message :: String.t) :: Macro.t
  defmacro new(message \\ "") do
    quote do
      Errors.WrappedError.exception(env: __ENV__, message: unquote(message))
    end
  end

  @doc """
  Cause recursively unfurls a passed-in value that implements Cause.

  It will return the first value that does not implement Cause.
  """
  @spec cause(error :: Errors.Cause.t | any) :: Exception.t | any
  def cause(error) do
    try do
      Errors.Cause.cause(error)
    rescue
      Protocol.UndefinedError -> error
    end
  end
end

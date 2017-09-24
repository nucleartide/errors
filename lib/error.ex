defmodule Error do
  defmacro wrap(error, message \\ "") do
    quote do
      WrappedError.exception(
        error:   unquote(error),
        env:     __ENV__,
        message: unquote(message)
      )
    end
  end

  defmacro new(message \\ "") do
    quote do
      WrappedError.exception(env: __ENV__, message: unquote(message))
    end
  end

  def with_message(error, message \\ "") do
    WrappedError.exception(error: error, message: message, env: nil)
  end

  defmacro with_stack(error) do
    quote do
      WrappedError.exception(
        error:   unquote(error),
        env:     __ENV__,
        message: nil
      )
    end
  end

  # x: test this, use Kernel.is_function/1 maybe
  def cause(error) do
    atom = error.__struct__
    atom.cause(error)
  end

  # TODO: format
  # TODO: format :verbose, more options
  # x: string.chars protocol - just messages
  # TODO: inspect protocol - more detailed
  def format() do
  end
end

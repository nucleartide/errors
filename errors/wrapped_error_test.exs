defmodule Errors.WrappedErrorTest do
  use ExUnit.Case
  doctest Errors.WrappedError
  require Errors

  @moduledoc """
  WrappedErrorTest tests error output.

  Error output tests should be placed here, since asserting the equality
  of stack traces is somewhat brittle.
  """

  test "wrap/2, Inspect.WrappedError.inspect/2" do
    assert {:ok, pid} = StringIO.open("")
    err = %RuntimeError{message: "this is an error"}
      |> Errors.wrap("jesse")
      |> Errors.wrap("jason")
    IO.inspect(pid, err, [])

    expected = ~s"""
** (Errors.WrappedError) jason
\ \ \ \ errors/wrapped_error_test.exs:17: Errors.WrappedErrorTest."test wrap/2, Inspect.WrappedError.inspect/2"/1
** (Errors.WrappedError) jesse
\ \ \ \ errors/wrapped_error_test.exs:16: Errors.WrappedErrorTest."test wrap/2, Inspect.WrappedError.inspect/2"/1
** (RuntimeError) this is an error
    """
    assert {:ok, {"", actual}} = StringIO.close(pid)
    assert actual == expected
  end

  test "new/1, Inspect.WrappedError.inspect/2" do
    assert {:ok, pid} = StringIO.open("")
    err = Errors.new("this is an error")
    IO.inspect(pid, err, [])

    expected = ~s"""
** (Errors.WrappedError) this is an error
\ \ \ \ errors/wrapped_error_test.exs:33: Errors.WrappedErrorTest."test new/1, Inspect.WrappedError.inspect/2"/1
    """
    assert {:ok, {"", actual}} = StringIO.close(pid)
    assert actual == expected
  end
end

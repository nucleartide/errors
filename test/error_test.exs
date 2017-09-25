defmodule ErrorsTest do
  use ExUnit.Case
  doctest Errors

  test "wrap/2" do
    err = %RuntimeError{}
    msg = "this is an error"

    assert %WrappedError{error: e, message: m} = Errors.wrap(err, msg)
    assert e == err
    assert m == msg
  end

  test "new/1" do
    msg = "is it dinner time yet"

    assert %WrappedError{message: m} = Errors.new(msg)
    assert m == msg
  end

  test "wrap/2, String.Chars.WrappedError.to_string/1" do
    assert {:ok, pid} = StringIO.open("")
    err = %RuntimeError{message: "this is an error"}
      |> Errors.wrap("jesse")
      |> Errors.wrap("jason")
    IO.write(pid, err)

    assert {:ok, {"", "jason: jesse: this is an error"}} = StringIO.close(pid)
  end

  test "new/1, String.Chars.WrappedError.to_string/1" do
    assert {:ok, pid} = StringIO.open("")
    err = Errors.new("this is also an error")
    IO.write(pid, err)

    assert {:ok, {"", "this is also an error"}} = StringIO.close(pid)
  end

  test "wrap/2, Inspect.WrappedError.inspect/2" do
    assert {:ok, pid} = StringIO.open("")
    err = %RuntimeError{message: "this is an error"}
      |> Errors.wrap("jesse")
      |> Errors.wrap("jason")
    IO.inspect(pid, err, [])

    expected = ~s"""
** (WrappedError) jason
\ \ \ \ test/error_test.exs:43: ErrorsTest."test wrap/2, Inspect.WrappedError.inspect/2"/1
** (WrappedError) jesse
\ \ \ \ test/error_test.exs:42: ErrorsTest."test wrap/2, Inspect.WrappedError.inspect/2"/1
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
** (WrappedError) this is an error
\ \ \ \ test/error_test.exs:59: ErrorsTest."test new/1, Inspect.WrappedError.inspect/2"/1
    """
    assert {:ok, {"", actual}} = StringIO.close(pid)
    assert actual == expected
  end
end

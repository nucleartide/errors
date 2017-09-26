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

  test "cause/1" do
    assert nil == Errors.cause(nil)
    assert 42 = Errors.cause(42)
    assert "flank steak" = Errors.cause("flank steak")

    assert nil == Errors.new() |> Errors.cause()
    assert %RuntimeError{} = %RuntimeError{} |> Errors.wrap() |> Errors.cause()

    e = %RuntimeError{} |> Errors.wrap() |> Errors.wrap()
    assert %RuntimeError{} = e |> Errors.cause()
  end

  test "wrap/2, String.Chars.WrappedError.to_string/1" do
    assert {:ok, pid} = StringIO.open("")
    err = %RuntimeError{message: "this is an error"} |> Errors.wrap("uh oh")
    IO.write(pid, err)

    assert {:ok, {"", e}} = StringIO.close(pid)
    assert "uh oh: this is an error" = e

    assert {:ok, pid} = StringIO.open("")
    err = %RuntimeError{} |> Errors.wrap("no message")
    IO.write(pid, err)

    assert {:ok, {"", e}} = StringIO.close(pid)
    assert "no message: runtime error" = e
  end

  test "new/1, String.Chars.WrappedError.to_string/1" do
    assert {:ok, pid} = StringIO.open("")
    err = Errors.new("this is also an error")
    IO.write(pid, err)

    assert {:ok, {"", e}} = StringIO.close(pid)
    assert "this is also an error" = e
  end

end

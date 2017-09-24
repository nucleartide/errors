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

  test "unwrap/1" do
    defmodule SomeError do
      @behaviour Unwrap
      defexception [:message]
      def unwrap(%SomeError{message: m}), do: RuntimeError.exception(m)
    end

    msg = "blah"
    err = SomeError.exception(msg) |> Errors.unwrap()

    assert %RuntimeError{message: msg} == err
  end

  test "unwrap/1, doesn't implement Unwrap" do
    msg = "Elixir.RuntimeError doesn't implement Unwrap"
    assert_raise RuntimeError, msg, fn -> Errors.unwrap(%RuntimeError{}) end
  end
end

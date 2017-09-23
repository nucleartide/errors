defmodule ErrorTest do
  use ExUnit.Case
  doctest Error

  test "greets the world" do
    assert Error.hello() == :world
  end
end

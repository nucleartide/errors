defmodule Program do
  require Error

  # "test" |> IO.write()
  # Error.new() |> IO.inspect() |> IO.puts()

  def main() do
    %RuntimeError{message: "shit"}
    |> Error.wrap("baz")
    |> Error.wrap("bar")
    |> Error.wrap("foo")
    #    |> Error.cause()
    |> IO.inspect()

    #raise "something"

# a = 4
# Error.new()
# |> IO.inspect()
  end
end


Program.main()

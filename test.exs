#defmodule Something do
#  defmacro hello do
#    a = __CALLER__
#    IO.inspect(a)
#
#    a = __ENV__
#    IO.inspect(a)
#
#    quote do
#      IO.puts "hello world"
#      IO.inspect("blah")
#    end
#  end
#end
#
#defmodule Program do
#  # require Errors
#  require Something
#
#  # "test" |> IO.write()
#  # Errors.new() |> IO.inspect() |> IO.puts()
#
#  def main() do
##    %RuntimeError{message: "shit"}
##    |> Errors.wrap("baz")
##    |> Errors.wrap("bar")
##    |> Errors.wrap("foo")
##    #    |> Errors.cause()
##    |> IO.inspect()
#
## IO.inspect(__CALLER__)
#    Something.hello()
#
#    #raise "something"
#
## a = 4
## Errors.new()
## |> IO.inspect()
#  end
#end
#
#
#Program.main()



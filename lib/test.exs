defmodule Something do
  defmacro hello({a, b, c}, e \\ "") when is_tuple(e) do
    IO.puts("hello world")
  end
end

defmodule Program do
  require Something

  def main() do
    a = "hello"
    Something.hello(%RuntimeError{}, a)
  end
end
Program.main()


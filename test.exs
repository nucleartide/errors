defmodule Test do
require Errors

%RuntimeError{}
|> Errors.wrap("blah")
|> Errors.wrap("blah")
|> IO.inspect(width: 40,label: "a wonderful range")



end


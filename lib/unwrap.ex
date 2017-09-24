defmodule Unwrap do
  @callback unwrap(Exception.t) :: Exception.t
end

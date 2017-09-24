# TODO: change this to a protocol
defmodule Causer do
  @callback cause(Exception.t) :: Exception.t
end

defmodule Causer do
  @callback cause(Exception.t) :: Exception.t
end

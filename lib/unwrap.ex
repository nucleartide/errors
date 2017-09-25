defprotocol Unwrap do
  @doc """
  Return an Exception's underlying Exception.

  See the link below for info about Dialyzer warnings:
  https://elixirforum.com/t/dialyzer-listed-not-implemented-protocols-as-unknown-functions/2099/9
  """
  @spec unwrap(error :: Unwrap.t) :: Exception.t
  def unwrap(error)
end

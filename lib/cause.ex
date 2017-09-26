defprotocol Cause do
  @doc """
  Return the underlying cause of an Exception.

  See the link below for info about Dialyzer warnings:
  https://elixirforum.com/t/dialyzer-listed-not-implemented-protocols-as-unknown-functions/2099/9
  """
  @spec cause(error :: Cause.t) :: Exception.t
  def cause(error)
end

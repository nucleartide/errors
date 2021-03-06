defprotocol Errors.Cause do
  @doc """
  Return the underlying cause of an Exception.

  See this link for info about Dialyzer warnings:
  https://elixirforum.com/t/dialyzer-listed-not-implemented-protocols-as-unknown-functions/2099/9
  """
  @spec cause(error :: Errors.Cause.t) :: Exception.t
  def cause(error)
end

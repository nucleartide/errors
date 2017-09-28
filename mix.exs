defmodule Errors.Mixfile do
  use Mix.Project

  def project do
    [
      app: :errors,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,

      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/nucleartide/errors",

      test_paths: ["."],
      elixirc_paths: File.ls!()
        |> Enum.filter(fn path -> File.dir?(path) end)
        |> Enum.filter(&include_file?/1),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description() do
    """
    Errors is an Elixir package that adds debugging context to error reasons. It
    is meant to be used in the tagged tuple style of error handling, where a
    function may return `{:ok, result}` or `{:error, reason}`.
    """
  end

  defp package() do
    [
      maintainers: ["Jason Tu"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nucleartide/errors"},
      files: File.ls!() |> Enum.filter(&include_file?/1)
    ]
  end

  defp include_file?(path) do
    not Enum.member?([".git", "_build", "deps"], path)
  end
end

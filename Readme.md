![Errors](https://user-images.githubusercontent.com/914228/30893941-d0a39f10-a30e-11e7-9539-d37ffdc56922.png)

Errors is an Elixir package that adds context to `reason`s in the `{:ok, result} | {:error, reason}` style of error handling.

#### Motivation

To illustrate why this might be useful, consider the following code snippet:

```elixir
# http.ex
defmodule HTTP do
  @spec get(url :: String.t) :: {:ok, HTTPoison.Response.t} | {:error, Exception.t}
  def get(url) do
    HTTPoison.get(url)
  end
end

# github.ex
defmodule GitHub do
  @type github_file :: {user :: String.t, repo :: String.t, file :: String.t}
  @spec file(github_file) :: {:ok, String.t} | {:error, Exception.t}
  def file({user, repo, file}) do
    HTTP.get("https://raw.githubusercontent.com/#{user}/#{repo}/master/#{file}")
  end
end

# file.ex
defmodule Repo do
  @spec read(path :: String.t) :: {:ok, String.t} | {:error, Exception.t}
  def read(path) do
    GitHub.file({"nucleartide", "errors", path})
  end
end

# iex> Repo.read("notafile.txt")
# ...> {:error, %HTTPoison.Error{id: nil, reason: :closed}}
```

Here, we know that the `Repo.read/1` operation failed, but the error reason isn't particularly helpful. Where is this `HTTPoison.Error` coming from? What was `:closed`?

This error is even more opaque if `Repo.read/1` comes from a third-party library.

#### Solution

Errors clarifies error reasons by annotating reasons with a message and stack trace. Here's how you would refactor the code above to provide additional debugging context:

```elixir
# http.ex
defmodule HTTP do
  @spec get(url :: String.t) :: {:ok, HTTPoison.Response.t} | {:error, Exception.t}
  def get(url) do
    with {:ok, res} <- HTTPoison.get(url) do
      res
    else
      err -> {:error, Errors.wrap(err, "http request failed")}
    end
  end
end

# github.ex
defmodule GitHub do
  @type github_file :: {user :: String.t, repo :: String.t, file :: String.t}
  @spec file(github_file) :: {:ok, String.t} | {:error, Exception.t}
  def file({user, repo, file}) do
    url = "https://raw.githubusercontent.com/#{user}/#{repo}/master/#{file}"
    with {:ok, res} <- HTTP.get(url) do
      res
    else
      err -> {:error, Errors.wrap(err, "couldn't fetch #{url}")}
    end
  end
end

# file.ex
defmodule Repo do
  @spec read(path :: String.t) :: {:ok, String.t} | {:error, Exception.t}
  def read(path) do
    with {:ok, res} <- GitHub.file({"nucleartide", "errors", path}) do
      res
    else
      err -> {:error, Errors.wrap(err, "couldn't read from #{path}")}
    end
  end
end

# iex> Repo.read("notafile.txt")
# ...> {:error, %Errors.WrappedError{...}}
```

## Install

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `errors` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:errors, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/errors](https://hexdocs.pm/errors).

## Feedback, issues, concerns

Please open an [issue]().

---

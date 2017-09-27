![Errors](https://user-images.githubusercontent.com/914228/30893941-d0a39f10-a30e-11e7-9539-d37ffdc56922.png)

Errors is an Elixir package that adds context to `reason`s in the `{:ok, result} | {:error, reason}` style of error handling.

#### Motivation

To illustrate why this might be useful, consider the following code snippet:

```elixir
defmodule HTTP do
  def get(url) do
    HTTPoison.get(url)
  end
end

defmodule GitHub do
  def file({user, repo, file}) do
    HTTP.get("https://raw.githubusercontent.com/#{user}/#{repo}/master/#{file}")
  end
end

defmodule Repo do
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
defmodule HTTP do
  def get(url) do
    with {:ok, res} <- HTTPoison.get(url) do
      res
    else
      err -> {:error, Errors.wrap(err, "http request failed")}
    end
  end
end

defmodule GitHub do
  def file({user, repo, file}) do
    url = "https://raw.githubusercontent.com/#{user}/#{repo}/master/#{file}"
    with {:ok, res} <- HTTP.get(url) do
      res
    else
      err -> {:error, Errors.wrap(err, "couldn't fetch github file")}
    end
  end
end

defmodule Repo do
  def read(path) do
    with {:ok, res} <- GitHub.file({"nucleartide", "errors", path}) do
      res
    else
      err -> {:error, Errors.wrap(err, "couldn't read from #{path}")}
    end
  end
end

# iex> {:error, err} = Repo.read("notafile.txt")
# ...> {:error, %Errors.WrappedError{...}}
```

We can print this new `Errors.WrappedError` to understand exactly what went wrong:

```
iex> IO.puts(err)
couldn't read from notafile.txt: couldn't fetch github file: http request failed: closed
```

Or inspect the error for a stack trace:

```
iex> IO.inspect(err)
** (Errors.WrappedError) jason
    example.exs:27: HTTP.get/1
** (Errors.WrappedError) jesse
    example.exs:17: GitHub.file/1
** (Errors.WrappedError) jesse
    example.exs:6: Repo.read/1
** (HTTPoison.Error) closed
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

## API

TODO

## Feedback, issues, concerns

Please open an [issue](https://github.com/nucleartide/errors/issues/new).

---

```
links and stuff go here
```

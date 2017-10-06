![Errors](https://user-images.githubusercontent.com/914228/30893941-d0a39f10-a30e-11e7-9539-d37ffdc56922.png)

Errors is an Elixir package that adds debugging context to error reasons. It is meant to be used in the tagged tuple style of error handling, where a function may return `{:ok, result}` or `{:error, reason}`.

## Motivation

To illustrate why this might be useful, consider the following code snippet that fetches the contents of a file from a GitHub repo:

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

Here, we see that the `Repo.read/1` operation failed, but the error reason isn't particularly helpful. Where does the `HTTPoison.Error` come from? What was `:closed`?

This error is even more opaque if `Repo.read/1` comes from a third-party library.

#### Solution

Errors clarifies error reasons by annotating reasons with a message and stack trace. Here's how you would refactor the code above to provide additional debugging context:

```elixir
defmodule HTTP do
  def get(url) do
    with res = {:ok, _} <- HTTPoison.get(url) do
      res
    else
      {:error, e} -> {:error, Errors.wrap(e, "http request failed")}
    end
  end
end

defmodule GitHub do
  defp url({user, repo, file}) do
    "https://raw.githubusercontent.com/#{user}/#{repo}/master/#{file}"
  end

  def file(github_file) do
    with res = {:ok, _} <- HTTP.get(github_file |> url()) do
      res
    else
      {:error, e} -> {:error, Errors.wrap(e, "couldn't fetch github file")}
    end
  end
end

defmodule Repo do
  def read(path) do
    with res = {:ok, _} <- GitHub.file({"nucleartide", "errors", path}) do
      res
    else
      {:error, e} -> {:error, Errors.wrap(e, "couldn't read from #{path}")}
    end
  end
end

# iex> {:error, err} = Repo.read("notafile.txt")
# ...> {:error, %Errors.WrappedError{...}}
```

We can print this new `Errors.WrappedError` to retrieve our annotated messages:

```
iex> IO.puts(err)
couldn't read from notafile.txt: couldn't fetch github file: http request failed: closed
```

Or inspect the error for a stack trace:

```
iex> IO.inspect(err)
** (Errors.WrappedError) couldn't read from notafile.txt
    example.exs:27: HTTP.get/1
** (Errors.WrappedError) couldn't fetch github file
    example.exs:17: GitHub.file/1
** (Errors.WrappedError) http request failed
    example.exs:6: Repo.read/1
** (HTTPoison.Error) closed
```

## Install

Add `:errors` to your `deps` in `mix.exs`:

```elixir
def deps do
  [
    {:errors, "~> 0.1.0"}
  ]
end
```

## API

Errors exposes three primary macros/functions:

#### `Errors.wrap/2`

```elixir
@spec wrap(error :: Exception.t, message :: String.t) :: Macro.t
defmacro wrap(error, message \\ "")
```

Use `Errors.wrap/2` to "wrap" tagged errors received from other functions:

```elixir
defmodule YourModule do
  require Errors

  def get() do
    with res = {:ok, _} <- HTTPoison.get("https://www.google.com/") do
      res
    else
      {:error, e} -> {:error, Errors.wrap(e, "can't ping google")}
    end
  end
end
```

#### `Errors.new/1`

```elixir
@spec new(message :: String.t) :: Macro.t
defmacro new(message \\ "")
```

Use `Errors.new/1` as a general replacement for custom Exception structs:

```elixir
defmodule YourModule do
  require Errors

  def transform("https://" <> rest_of_link),
    do: {:ok, rest_of_link}
  def transform(_),
    do: {:error, Errors.new("missing https:// prefix")}
end
```

#### `Errors.cause/1`

```elixir
@spec cause(error :: Errors.Cause.t | any) :: Exception.t | any
def cause(error)
```

`Errors.cause/1` returns the unwrapped "cause" of an error.

The passed-in `error` should implement the `Errors.Cause` protocol; errors returned by `Errors.wrap/2` and `Errors.new/1` implement `Errors.Cause` already:

```elixir
require Errors

%RuntimeError{message: "this is an error"}
|> Errors.wrap("uh-oh")
|> Errors.cause() # => %RuntimeError{message: "this is an error"}
```

#### `WrappedError`

`Errors.wrap/2` and `Errors.new/1` return a `WrappedError`. `WrappedError` implements the String.Chars and Inspect protocols, so you can freely print and inspect:

```elixir
e = %RuntimeError{} |> Errors.wrap("uh-oh")
IO.puts(e)    # will print "uh-oh: runtime error"
IO.inspect(e) # will print a stack trace
```

#### Hexdocs

See the [hexdocs](https://hexdocs.pm/errors) for more details and links to source code.

## Feedback, issues, concerns

Please open an [issue](https://github.com/nucleartide/errors/issues/new)!

## Links

- [Introduction blog post](https://medium.com/@nucleartide/graceful-error-handling-in-elixir-c611106e140c)

---

> ![](https://cloud.githubusercontent.com/assets/914228/25078295/869950f2-22ff-11e7-8c78-6b5397a8ac72.png)
>
> Jason Tu · GitHub [@nucleartide](https://github.com/nucleartide · Twitter [@nucleartide](https://twitter.com/nucleartide)

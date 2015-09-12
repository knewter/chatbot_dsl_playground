defmodule ChatbotDSL.JSONASTConverter do
  @moduledoc """
  The JSONASTConverter takes in a JSON AST and returns our custom AST.
  It exists to allow us to get around the fact that JSON doesn't support
  tuples and atoms, essentially.
  """

  def convert(json) do
    json
    |> Poison.decode!
    |> do_convert
  end

  def do_convert(%{"type" => "if", "arguments" => arguments}) do
    {:if, Enum.map(arguments, &do_convert/1)}
  end
  def do_convert(%{"type" => "atom", "arguments" => [word]}) do
    String.to_atom(word)
  end
  def do_convert(%{"type" => "string", "arguments" => [word]}) do
    word
  end
  def do_convert(%{"type" => "contains", "arguments" => arguments}) do
    {:contains, Enum.map(arguments, &do_convert/1)}
  end
  def do_convert(%{"type" => "var", "arguments" => [var]}) do
    {:var, do_convert(var)}
  end
  def do_convert(%{"type" => "response", "arguments" => [response]}) do
    {:response, response}
  end
  def do_convert(x) when is_binary(x), do: x
end

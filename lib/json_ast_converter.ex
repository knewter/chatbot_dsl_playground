defmodule JsonAstConverter do
  def convert(json) do
    Poison.decode!(json)
    |> do_convert
  end

  def do_convert(["tuple"|rest]) do
    build_tuple(rest, {})
  end
  def do_convert(["atom", word]) do
    String.to_atom(word)
  end
  def do_convert(["string", word]) do
    word
  end

  def build_tuple([head|rest], acc) do
    acc2 = :erlang.append_element(acc, do_convert(head))
    build_tuple(rest, acc2)
  end
  def build_tuple([], acc), do: acc
end

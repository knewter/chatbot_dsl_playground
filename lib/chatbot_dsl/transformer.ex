defmodule ChatbotDSL.Transformer do
  @moduledoc """
  The ChatbotDSL.Transformer transforms our custom AST into elixir AST
  structures.
  """

  @type expression_type :: :if | :contains | :var | :response
  @type expression :: {expression_type, list(expression)}

  @spec generate_elixir(expression) :: any # really returns an elixir ast
  def generate_elixir(ast) do
    do_generate_elixir(ast)
  end

  # if-else
  def do_generate_elixir({:if, [conditional, first, second]}) do
    quote do
      if unquote(do_generate_elixir(conditional)) do
        unquote(do_generate_elixir(first))
      else
        unquote(do_generate_elixir(second))
      end
    end
  end
  # if
  def do_generate_elixir({:if, [conditional, first]}) do
    quote do
      if unquote(do_generate_elixir(conditional)) do
        unquote(do_generate_elixir(first))
      end
    end
  end
  def do_generate_elixir({:var, var}) do
    {:var!,
      [context: ChatbotDSL.Transformer, import: Kernel],
      [{var, [], Elixir}]
    }
  end
  def do_generate_elixir(x) when is_binary(x), do: x
  def do_generate_elixir({:response, response}) do
    Macro.escape(%ChatbotDSL.Message{body: response})
  end
  def do_generate_elixir(true), do: true
  def do_generate_elixir(false), do: false

  def do_generate_elixir({:contains, [left, right]}) do
    quote do
      unquote(do_generate_elixir(left)) =~ unquote(do_generate_elixir(right))
    end
  end
end

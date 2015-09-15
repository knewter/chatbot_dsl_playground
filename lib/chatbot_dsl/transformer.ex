defmodule ChatbotDSL.Transformer do
  @moduledoc """
  The ChatbotDSL.Transformer transforms our custom AST into elixir AST
  structures.
  """

  def generate_elixir(ast) do
    do_generate_elixir(ast)
  end

  # if-else
  def do_generate_elixir({:if, [conditional, first, second]}) do
    quote do
      if unquote(handle_conditional(conditional)) do
        unquote(do_generate_elixir(first))
      else
        unquote(do_generate_elixir(second))
      end
    end
  end
  # if
  def do_generate_elixir({:if, [conditional, first]}) do
    quote do
      if unquote(handle_conditional(conditional)) do
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

  def handle_conditional({:contains, [left, right]}) do
    quote do
      unquote(do_generate_elixir(left)) =~ unquote(do_generate_elixir(right))
    end
  end
end

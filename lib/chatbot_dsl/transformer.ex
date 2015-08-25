defmodule ChatbotDSL.Transformer do
  def generate_elixir(ast) do
    do_generate_elixir(ast)
  end

  # if-else
  def do_generate_elixir({:if, [conditional, first, second]}) do
    {:if, [context: Elixir, import: Kernel],
      [handle_conditional(conditional),
        [do: Macro.escape(first),
         else: Macro.escape(second)]]}
  end
  # if
  def do_generate_elixir({:if, conditional, first}) do
    {:if, [context: Elixir, import: Kernel],
      [handle_conditional(conditional),
        [do: Macro.escape(first)]]}
  end
  def do_generate_elixir({:var, var}) do
       {:var!, [context: Elixir, import: Kernel], [{var, [], Elixir}]}
  end
  def do_generate_elixir(x) when is_binary(x), do: x

  def handle_conditional({:contains, [left, right]}) do
     {:=~, [context: Elixir, import: Kernel],
       [do_generate_elixir(left), do_generate_elixir(right)]}
  end
end

defmodule Transformer do
  def generate_elixir(ast) do
    do_generate_elixir(ast)
  end

  # if-else
  def do_generate_elixir({:if, conditional, first, second}) do
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

  def handle_conditional({var, :contains, val}) do
     {:=~, [context: Elixir, import: Kernel],
       [{:var!, [context: Elixir, import: Kernel], [{var, [], Elixir}]},
          val]}
  end
end

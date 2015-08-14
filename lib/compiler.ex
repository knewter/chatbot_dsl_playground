defmodule Compiler do
  def generate_elixir(ast) do
    do_generate_elixir(ast)
  end

  def do_generate_elixir({:if, conditional, first, second}) do
    {:if, [context: Elixir, import: Kernel],
      [handle_conditional(conditional),
        [do: first,
         else: second]]}
  end

  def handle_conditional({var, :contains, val}) do
     {:=~, [context: Elixir, import: Kernel],
       [{:var!, [context: Elixir, import: Kernel], [{var, [], Elixir}]},
          val]}
  end
end

defmodule ChatbotDSL.Transformer do
  def generate_elixir(ast) do
    do_generate_elixir(ast)
  end

  # if-else
  def do_generate_elixir({:if, [conditional, first, second]}) do
    {:if, [context: Elixir, import: Kernel],
      [handle_conditional(conditional),
        [do: do_generate_elixir(first),
         else: do_generate_elixir(second)]]}
  end
  # if
  def do_generate_elixir({:if, [conditional, first]}) do
    {:if, [context: Elixir, import: Kernel],
      [handle_conditional(conditional),
        [do: do_generate_elixir(first)]]}
  end
  def do_generate_elixir({:var, var}) do
    {:var!, [context: Elixir, import: Kernel], [{var, [], Elixir}]}
  end
  def do_generate_elixir(x) when is_binary(x), do: x
  def do_generate_elixir({:response, response}) do
    Macro.escape(%ChatbotDSL.Message{body: response})
  end
  def do_generate_elixir(true), do: true
  def do_generate_elixir(false), do: false

  def handle_conditional({:contains, [left, right]}) do
     {:=~, [context: Elixir, import: Kernel],
       [do_generate_elixir(left), do_generate_elixir(right)]}
  end
end

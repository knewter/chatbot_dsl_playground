defmodule ChatbotDSL.TransformerTest do
  use ExUnit.Case
  alias ChatbotDSL.Transformer

  @ast {:if, [
               {
                 :contains,
                 [
                   {:var, :input},
                   "filthy"
                 ]
               },
               true,
               false
             ]
       }

  @elixir_ast {:if, [context: Elixir, import: Kernel],
                 [{:=~, [context: Elixir, import: Kernel],
                   [{:var!, [context: Elixir, import: Kernel], [{:input, [], Elixir}]},
                      "filthy"]},
                  [do: true,
                   else: false]]}

  test "we can compile our AST into the Elixir AST" do
    compiled = @ast |> Transformer.generate_elixir
    assert compiled == @elixir_ast
  end
end

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

  @elixir_ast {:if,
                [context: ChatbotDSL.Transformer, import: Kernel],
                [{:=~, [context: ChatbotDSL.Transformer, import: Kernel],
                  [{:var!,
                    [context: ChatbotDSL.Transformer, import: Kernel], [{:input, [], Elixir}]},
                    "filthy"
                  ]},
                  [do: true,
                   else: false]]}

  @tableflip_ast {
    :if, [
      {
        :contains,
        [
          {:var, :body},
          ":tableflip:"
        ]
      },
      {
        :response,
        "(╯°□°）╯︵ ┻━┻"
      }
    ]
  }

  @tableflip_elixir_ast {
    :if,
    [context: ChatbotDSL.Transformer, import: Kernel],
    [
      {
        :=~,
        [context: ChatbotDSL.Transformer, import: Kernel],
        [
          {
            :var!,
            [context: ChatbotDSL.Transformer, import: Kernel],
            [
              {
                :body,
                [],
                Elixir
              }
            ]
          },
          ":tableflip:"
        ]
      },
      [do: {:%{}, [], [__struct__: ChatbotDSL.Message, body: "(╯°□°）╯︵ ┻━┻"]}]
    ]
  }


  test "we can compile our AST into the Elixir AST" do
    compiled = @ast |> Transformer.generate_elixir
    assert compiled == @elixir_ast
  end

  test "we can compile our tableflip AST into the Elixir tableflip AST" do
    compiled = @tableflip_ast |> Transformer.generate_elixir
    assert compiled == @tableflip_elixir_ast
  end
end

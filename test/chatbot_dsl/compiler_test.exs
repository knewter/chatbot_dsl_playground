defmodule ChatbotDSL.CompilerTest do
  use ExUnit.Case
  alias ChatbotDSL.Compiler
  alias ChatbotDSL.JsonAstConverter
  alias ChatbotDSL.Response

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

  @tableflip_response %Response{message: "(╯°□°）╯︵ ┻━┻"}

  @ast2 {:if, {
                :contains,
                [
                  {:var, :input},
                  ":tableflip:"
                ]
              },
              @tableflip_response
        }

  @input "Bob is filthy"
  @bad_input "Bob is clean"

  @json_ast """
  {
    "type": "if",
    "arguments": [
      {
        "type": "contains",
        "arguments": [
          {"type": "var", "arguments": [{"type": "atom", "arguments": ["input"]}]},
          {"type": "string", "arguments": ["filthy"]}
        ]
      },
      {"type": "atom", "arguments": ["true"]},
      {"type": "atom", "arguments": ["false"]}
    ]
  }
  """

  test "we can evaluate some AST" do
    compiled = @ast |> Compiler.compile
    assert compiled.(@input) == true
    assert compiled.(@bad_input) == false
  end

  test "responding with a tableflip" do
    compiled = @ast2 |> Compiler.compile
    assert compiled.(":tableflip:") == @tableflip_response
    assert compiled.("anything else") == nil
  end

  test "we can evaluate the json AST" do
    ast = JsonAstConverter.convert(@json_ast)
    compiled = ast |> Compiler.compile
    assert compiled.(@input) == true
    assert compiled.(@bad_input) == false
  end
end

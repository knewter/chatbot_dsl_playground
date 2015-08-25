defmodule ChatbotDSL.CompilerTest do
  use ExUnit.Case
  alias ChatbotDSL.Compiler
  alias ChatbotDSL.JsonAstConverter
  alias ChatbotDSL.Message

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

  @tableflip_string "(╯°□°）╯︵ ┻━┻"
  @tableflip_response %Message{body: @tableflip_string}

  @ast2 {:if, [
                {
                  :contains,
                  [
                    {:var, :input},
                    ":tableflip:"
                  ]
                },
                {:response, @tableflip_string}
              ]
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

  @json_tableflip_ast """
  {
    "type": "if",
    "arguments": [
      {
        "type": "contains",
        "arguments": [
          {"type": "var", "arguments": [{"type": "atom", "arguments": ["input"]}]},
          {"type": "string", "arguments": [":tableflip:"]}
        ]
      },
      {"type": "response", "arguments": ["(╯°□°）╯︵ ┻━┻"]}
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

  test "we can evaluate the json tableflip AST" do
    ast = JsonAstConverter.convert(@json_tableflip_ast)
    compiled = ast |> Compiler.compile
    assert compiled.(":tableflip:") == @tableflip_response
    assert compiled.("anything else") == nil
  end
end

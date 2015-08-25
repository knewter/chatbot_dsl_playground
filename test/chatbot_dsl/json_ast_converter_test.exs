defmodule ChatbotDSL.JsonAstConverterTest do
  use ExUnit.Case
  alias ChatbotDSL.JsonAstConverter

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

  @tableflip_ast {:if,
                   [
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

  test "converting our basic ast from JSON" do
    assert JsonAstConverter.convert(@json_ast) == @ast
  end
  test "converting our basic ast from JSON" do
    assert JsonAstConverter.convert(@json_tableflip_ast) == @tableflip_ast
  end
end

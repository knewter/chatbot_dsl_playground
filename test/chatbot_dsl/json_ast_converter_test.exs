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

  test "converting our basic ast from JSON" do
    assert JsonAstConverter.convert(@json_ast) == @ast
  end
end

defmodule JsonAstConverterTest do
  use ExUnit.Case

  @json_ast """
       ["tuple",
         ["atom", "if"],
         ["tuple",
               ["atom", "input"],
               ["atom", "contains"],
               ["string", "filthy"]
         ],
         ["atom", "true"],
         ["atom", "false"]
       ]
  """

  @ast {:if, {
               :input,
               :contains,
               "filthy"
             },
             true,
             false
       }

  test "converting our basic ast from JSON" do
    assert JsonAstConverter.convert(@json_ast) == @ast
  end
end

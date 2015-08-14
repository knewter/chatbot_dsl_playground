defmodule ChatbotDslPlaygroundTest do
  use ExUnit.Case

  @ast {:if, {
               :input,
               :contains,
               "filthy"
             },
             true,
             false
       }

  @tableflip_response %Response{message: "(╯°□°）╯︵ ┻━┻"}

  @ast2 {:if, {
               :input,
               :contains,
               ":tableflip:"
             },
             @tableflip_response
        }

  @input "Bob is filthy"
  @bad_input "Bob is clean"

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
end

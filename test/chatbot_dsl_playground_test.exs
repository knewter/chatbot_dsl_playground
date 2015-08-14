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

  @input "Bob is filthy"
  @bad_input "Bob is clean"

  test "we can evaluate some AST" do
    compiled = @ast |> Evaluator.evaluate
    assert compiled.(@input) == true
    assert compiled.(@bad_input) == false
  end
end

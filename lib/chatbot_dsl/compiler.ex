defmodule ChatbotDSL.Compiler do
  @moduledoc """
  The Compiler takes in our ast and returns an anonymous function that will
  evaluate the ast against an input document.
  """

  def compile(ast) do
    quoted = ChatbotDSL.Transformer.generate_elixir(ast)

    fn(input) ->
      {val, _binding} = Code.eval_quoted(quoted, [input: input])
      val
    end
  end
end

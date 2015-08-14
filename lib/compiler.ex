defmodule Compiler do
  def compile(ast) do
    quoted = Transformer.generate_elixir(ast)

    fn(input) ->
      {val, _binding} = Code.eval_quoted(quoted, [input: input])
      val
    end
  end
end

defmodule Evaluator do
  def evaluate(ast) do
    quoted = Compiler.generate_elixir(ast)

    fn(input) ->
      {val, _binding} = Code.eval_quoted(quoted, [input: input])
      val
    end
  end
end

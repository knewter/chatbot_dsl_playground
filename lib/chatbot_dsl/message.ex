defmodule ChatbotDSL.Message do
  @type t :: %__MODULE__{body: String.t}
  defstruct body: ""
end

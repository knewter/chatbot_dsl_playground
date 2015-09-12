defmodule ChatbotDSL.Message do
  @moduledoc """
  A ChatbotDSL.Message is our internal struct that represents a message passing
  through the system.  These are the inputs that rules in this system are
  evaluated against.
  """

  @type t :: %__MODULE__{body: String.t}
  defstruct body: ""
end

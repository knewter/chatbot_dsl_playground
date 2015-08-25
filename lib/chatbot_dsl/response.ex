defmodule ChatbotDSL.Response do
  alias ChatbotDSL.Message

  defstruct messages: []
  @type t :: %__MODULE__{messages: list(Message.t)}

  def into(original) do
    {original, fn
      # Rules that return nil shouldn't affect the response
      source, {:cont, nil} -> source
      source=%__MODULE__{}, {:cont, message=%ChatbotDSL.Message{}} ->
        %__MODULE__{source | messages: [message|source.messages]}

      # The next pattern we care about is `done`, which is what is called when
      # the collection is complete.  We'll just return the source here.
      source, :done -> source

      # You should also handle the `halt` case, which can happen if a collection
      # is stopped before completing.  I can't think through all of the reasons
      # this might happen, but basically your return value isn't used so you
      # just define this clause so that you adhere to the protocol.
      _source, :halt -> :ok
    end}
  end
end

defimpl Collectable, for: ChatbotDSL.Response do
  defdelegate into(original), to: ChatbotDSL.Response
end

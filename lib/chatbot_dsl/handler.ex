defmodule ChatbotDSL.Handler do
  @moduledoc """
  A Hedwig Handler that will simply proxy the message to all running chatbots
  and handle their results accordingly.
  """

  use Hedwig.Handler

  def handle_event(%Message{} = msg, opts) do
  end
end

defmodule ChatbotDSL.Handler do
  @moduledoc """
  A Hedwig Handler that will simply proxy the message to all running chatbots
  and handle their results accordingly.
  """

  use Hedwig.Handler

  def handle_event(%Message{} = msg, opts) do
    responses = %ChatbotDSL.Message{body: msg.body}
                |> ChatbotDSL.Chatbot.scatter_gather
    for response <- responses do
      handle_response(msg, response)
    end
    {:ok, opts}
  end
  def handle_event(_, opts), do: {:ok, opts}

  defp handle_response(msg, %ChatbotDSL.Response{messages: messages}) do
    for message <- messages do
      reply(msg, Stanza.body(message.body))
    end
  end
end

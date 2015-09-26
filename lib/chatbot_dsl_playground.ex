defmodule ChatbotDSLPlayground do
  @moduledoc """
  The ChatbotDSLPlayground is an application that manages a group of chatbots
  that can have custom rules that they will evaluate against incoming Messages.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    :pg2.create(:chatbots)

    children = []
    if(Mix.env == :dev) do
      children = [
        worker(ChatbotDSL.Chatbot, [%ChatbotDSL.Chatbot.State{name: "upcaser", rules: [
          fn(%ChatbotDSL.Message{body: body}) ->
            if(body != String.upcase(body)) do
              %ChatbotDSL.Message{body: String.upcase(body)}
            end
          end,
          # fn(%ChatbotDSL.Message{body: body}) ->
          #   if(String.match?(body, ~r/:tableflip:/)) do
          #     %ChatbotDSL.Message{body: "(╯°□°）╯︵ ┻━┻"}
          #   end
          # end
        ]}]) | children]
    end

    opts = [strategy: :one_for_one, name: ChatbotDSLPlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

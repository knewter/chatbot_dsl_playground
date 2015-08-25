defmodule ChatbotDSLPlayground do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    :pg2.create(:chatbots)

    children = [
      worker(ChatbotDSL.Chatbot, [%ChatbotDSL.Chatbot.State{rules: [
              fn(%ChatbotDSL.Message{body: body}) ->
                %ChatbotDSL.Message{body: String.upcase(body)}
              end
            ]}])
    ]

    opts = [strategy: :one_for_one, name: ChatbotDSLPlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

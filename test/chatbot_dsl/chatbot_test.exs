defmodule ChatbotDSL.ChatbotRuleTestModule do
  def apply(%ChatbotDSL.Message{}) do
    %ChatbotDSL.Message{body: "A response!"}
  end
end

defmodule ChatbotDSL.ChatbotTest do
  alias ChatbotDSL.Message
  alias ChatbotDSL.Response
  alias ChatbotDSL.Chatbot
  alias ChatbotDSL.Chatbot.State
  alias ChatbotDSL.ChatbotRuleTestModule
  use ExUnit.Case

  test "starting a chatbot" do
    {:ok, pid} = Chatbot.start_link
    assert is_pid(pid)
  end

  test "starting a chatbot with its rules" do
    rules = [ChatbotRuleTestModule]
    assert {:ok, _pid} = Chatbot.start_link(%State{rules: rules})
  end

  test "starting a chatbot and sending it a message to evaluate" do
    rules = [ChatbotRuleTestModule]
    {:ok, pid} = Chatbot.start_link(%State{rules: rules})
    message = %Message{body: "giggity"}
    assert %Response{messages: [%Message{body: "A response!"}]} == Chatbot.evaluate_message(pid, message)
  end

end

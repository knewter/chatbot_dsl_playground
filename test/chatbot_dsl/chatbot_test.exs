defmodule ChatbotDSL.ChatbotRuleTestModule do
  def apply(%ChatbotDSL.Message{}) do
    %ChatbotDSL.Response{}
  end
end

defmodule ChatbotDSL.ChatbotTest do
  alias ChatbotDSL.Chatbot
  alias ChatbotDSL.ChatbotRuleTestModule
  use ExUnit.Case

  test "starting a chatbot" do
    {:ok, pid} = Chatbot.start_link
    assert is_pid(pid)
  end

  test "starting a chatbot with its rules" do
    rules = [ChatbotRuleTestModule]
    {:ok, pid} = Chatbot.start_link(rules)
  end
end

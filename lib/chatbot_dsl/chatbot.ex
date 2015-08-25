defmodule ChatbotDSL.Chatbot.State do
  defstruct rules: []
end

defmodule ChatbotDSL.Chatbot do
  use GenServer

  @moduledoc """
  The Chatbot is a GenServer that is used to idle in an xmpp chatroom and
  respond to messages, as a logged-in user.
  """

  ## Client API

  @typedoc """
  A rule implements an `apply/1` function that accepts a `%ChatbotDSL.Message{}` and returns an `%ChatbotDSL.Response{}`
  """
  @type rule :: atom

  @doc """
  Starts and links a Chatbot
  # A 'rules' is a list of modules that implement an `apply/1` method that accepts a `%ChatbotDSL.Message{}` and returns a `%ChatbotDSL.Response{}`
  """
  @spec start_link(list(rule)) :: {:ok, pid}
  def start_link(rules \\ []) do
    GenServer.start_link(__MODULE__, rules)
  end

  @doc """
  Evaluate a message in the context of the chatbot's current list of rules.
  """
  @spec evaluate_message(pid, ChatbotDSL.Message.t) :: ChatbotDSL.Response.t
  def evaluate_message(pid, %ChatbotDSL.Message{}=message) do
    GenServer.call(pid, {:evaluate_message, message})
  end

  ## Server API
  def init(rules) do
    {:ok, %ChatbotDSL.Chatbot.State{rules: rules}}
  end

  def handle_call({:evaluate_message, message}, _from, state) do
    response = for rule <- state.rules, into: %ChatbotDSL.Response{} do
                 rule.apply(message)
               end
    {:reply, response, state}
  end
end

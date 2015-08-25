defmodule ChatbotDSL.Chatbot do

  @moduledoc """
  The Chatbot is a GenServer that is used to idle in an xmpp chatroom and
  respond to messages, as a logged-in user.
  """

  use GenServer

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

  ## Server API


end

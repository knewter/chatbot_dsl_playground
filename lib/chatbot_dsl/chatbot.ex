defmodule ChatbotDSL.Chatbot.State do
  @moduledoc """
  The internal state for a Chatbot.

  This chatbot will be proxied to by a global Hedwig connection.  It just
  serves as a 'bucket' to hold a given ruleset, but each Chatbot is actually
  servicing the same XMPP connection for now.  I would expect this to change,
  but not terribly soon.
  """


  @typedoc """
  A rule can be implemented as either a module or a function.

  * The module form implements an `apply/1` function that accepts a
    `%ChatbotDSL.Message{}` and returns an `%ChatbotDSL.Response{}`
  * The function form follows the style of the `apply/1` function described
    above.
  """
  @type rule :: atom | (ChatbotDSL.Message.t -> ChatbotDSL.Response.t)

  @type t :: %__MODULE__{
    name: String.t,
    rules: list(rule)
  }
  defstruct name: "", rules: []
end

defmodule ChatbotDSL.Chatbot do
  use GenServer
  alias ChatbotDSL.Chatbot.State

  @moduledoc """
  The Chatbot is a GenServer that is used to idle in an xmpp chatroom and
  respond to messages, as a logged-in user.

      iex> state = %ChatbotDSL.Chatbot.State{}
      iex> {:ok, pid} = ChatbotDSL.Chatbot.start_link state
  """

  ## Client API

  @doc """
  Starts and links a Chatbot
  """
  @spec start_link(%State{}) :: {:ok, pid}
  def start_link(state=%State{} \\ %State{}) do
    GenServer.start_link(__MODULE__, state)
  end

  @doc """
  Evaluate a message in the context of the chatbot's current list of rules.

  * The `pid` argument is a `pid`.
  * The `message` argument is a `%ChatbotDSL.Message{}`.
  """
  @spec evaluate_message(pid, ChatbotDSL.Message.t) :: ChatbotDSL.Response.t
  def evaluate_message(pid, %ChatbotDSL.Message{}=message) do
    GenServer.call(pid, {:evaluate_message, message})
  end

  @doc """
  Scatters a message to all chatbots and gathers their responses.
  """
  @spec scatter_gather(ChatbotDSL.Message.t) :: list(ChatbotDSL.Response.t)
  def scatter_gather(%ChatbotDSL.Message{}=message) do
    for pid <- :pg2.get_members(:chatbots) do
      # FIXME: Doing this with Tasks makes more sense but YOLO
      evaluate_message(pid, message)
    end
  end

  ## Server API
  def init(%State{}=state) do
    :ok = :pg2.join(:chatbots, self)
    {:ok, state}
  end

  def handle_call({:evaluate_message, message}, _from, state) do
    response = for rule <- state.rules, into: %ChatbotDSL.Response{from: state.name} do
                 ChatbotDSL.Chatbot.apply(rule, message)
               end
    {:reply, response, state}
  end

  def apply(rule, message) when is_function(rule) do
    rule.(message)
  end
  def apply(rule, message) when is_atom(rule) do
    Kernel.apply(rule, :apply, [message])
  end
end

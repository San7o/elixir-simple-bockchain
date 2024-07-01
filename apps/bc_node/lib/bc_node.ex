defmodule BcNode do
  use GenServer
  require Logger

  @port BcNode.Constants.udp_port()
  @broadcast_ip BcNode.Constants.broadcast_ip()

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: :bc_node)
  end

  @impl true
  def init(:ok) do
    udp_options = [
      :binary,
      reuseaddr: true,
      broadcast: true
    ]

    Logger.info("Opening UDP socket on port #{@port}")
    :gen_udp.open(port, udp_options)
  end

  @impl true
  def handle_info({:udp, _socket, ip, port, data}, state) do
    Logger.info("Received broadcast #{inspect([ip, port, data])}")
    term = :erlang.binary_to_term(data)
    if BlockChain.Transaction.is_transaction(term) do 
      Logger.info("Received transaction #{inspect(term)}")
      BlockChain.Transactions.add_transaction(term)
    end
    {:noreply, state}
  end

  # Receive transactions from the other nodes in broadcst
  @impl true
  def handle_cast({:broadcast, transaction}, socket) do

    Logger.info("Broadcasting transaction #{inspect(transaction)}")
    data = :erlang.term_to_binary(transaction)
    :gen_udp.send(socket, @broadcast_ip, @port, data)
    {:noreply, socket}
  end
end

# Run this command to broadcast a message:
# socat STDIO UDP4-DATAGRAM:127.255.255.255:49998,broadcast

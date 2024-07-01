defmodule BcNode do
  use GenServer
  require Logger

  @port BcNode.Constants.udp_port()

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: :bc_node)
  end

  def init(:ok) do
    udp_options = [
      :binary,
      reuseaddr: true,
      broadcast: true
    ]

    Logger.info("Opening UDP socket on port #{@port}")
    {:ok, _socket} = :gen_udp.open(@port, udp_options)
  end

  def handle_info({:udp, _socket, ip, port, data}, state) do
    Logger.info("Received broadcast #{inspect([ip, port, data])}")
    {:noreply, state}
  end
end

# Run this command to broadcast a message:
# socat STDIO UDP4-DATAGRAM:127.255.255.255:49998,broadcast

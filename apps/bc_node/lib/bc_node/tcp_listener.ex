defmodule BcNode.TCPListener do
  use GenServer
  require Logger

  @moduledoc """
  This module listens for incoming TCP connections and processes them.
  TCP is used to send commands to the node.
  """

  @port BcNode.Constants.tcp_port()

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: :bc_node_tcp_listener)
  end

  def init(:ok) do
    port = String.to_integer(System.get_env("TCP_PORT") || "#{@port}")

    tcp_options = [
      :binary,
      packet: :line,
      active: false,
      reuseaddr: true
    ]

    Logger.info("Opening TCP socket on port #{port}")
    {:ok, socket} = :gen_tcp.listen(port, tcp_options)
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info("Accepted connection from #{inspect(client)}")
    {:ok, pid} = Task.Supervisor.start_child(BcNode.TaskSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    write_line(socket, {:ok, "node>"})

    msg =
      with {:ok, data} <- read_line(socket),
           {:ok, command} <- BcNode.Command.parse(data),
           do: BcNode.Command.run(command)

    write_line(socket, msg)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, text}) do
    :gen_tcp.send(socket, text)
  end

  defp write_line(socket, {:error, :unknown_command}) do
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    exit(:shutdown)
  end

  defp write_line(socket, {:error, :not_found}) do
    :gen_tcp.send(socket, "NOT FOUND\r\n")
  end

  defp write_line(socket, {:error, error}) do
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end
end

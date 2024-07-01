defmodule BcNode.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {BcNode, name: BcNode},
      {BcNode.Wallets, name: BcNode.Wallets},
      {Task.Supervisor, name: BcNode.TaskSupervisor},
      {BcNode.TCPListener, name: BcNode.TCPListener}
    ]

    Supervisor.init(children, strategy: :one_for_all, name: BcNode.Supervisor)
  end
end

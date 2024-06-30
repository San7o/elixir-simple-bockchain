defmodule BlockChain.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {BlockChain.Transactions, name: BlockChain.Transactions},
      {BlockChain.MerkleTreeStore, name: BlockChain.MerkleTreeStore},
      {BlockChain, name: BlockChain}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end

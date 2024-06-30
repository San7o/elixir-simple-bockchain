defmodule BlockChain do
  use Agent
  use Application

  @moduledoc """
  Documentation for `BlockChain`.
  """

  @impl true
  def start(_type, _args) do
    BlockChain.Supervisor.start_link([])
  end

  @doc """
  Starts the BlockChain Agent.
  """
  @spec start_link([any]) :: {:ok, String.t()} | {:error, term}
  def start_link(_opts) do
    {:ok, pid} = Agent.start_link(fn -> %{} end, name: __MODULE__)
    :ok = genesis_block()
    {:ok, pid}
  end

  # Genesis block for the BlockChain.
  # The genesis is the first block in the blockchain.
  # It is a special block that is hard coded and does not
  # reference a previous block.
  @spec genesis_block() :: :ok
  defp genesis_block() do
    wallet1 = BlockChain.Wallet.new()
    wallet2 = BlockChain.Wallet.new()
    transaction = BlockChain.Transaction.new(wallet1.public_key, wallet2.public_key, 1337)
    _wallet1 = BlockChain.Transactions.add_transaction(wallet1, transaction)
    mine_block()
  end

  # Adds a new block to the blockchain.
  #
  ## Parameters
  # - `block`: The block to add to the blockchain.
  @spec add_block(%BlockChain.Block{}) :: :ok
  defp add_block(block) do
    count = get_block_count()
    Agent.update(__MODULE__, &Map.put(&1, count + 1, block))
  end

  @doc """
  Gets a block from the blockchain.

  ## Parameters
  - `id`: The id of the block.
  """
  @spec get_block(integer) :: %BlockChain.Block{}
  def get_block(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  @doc """
  Gets the last block from the blockchain.
  """
  @spec get_last_block() :: %BlockChain.Block{}
  def get_last_block() do
    case get_block_count() do
      0 -> BlockChain.Block.new(1, "0", "0", [])
      count -> get_block(count)
    end
  end

  @doc """
  Gets all blocks from the blockchain.
  """
  @spec get_blocks() :: [BlockChain.Block.t()]
  def get_blocks() do
    Agent.get(__MODULE__, &Map.values(&1))
  end

  @doc """
  Gets the number of blocks in the blockchain.
  """
  @spec get_block_count() :: integer
  def get_block_count() do
    Agent.get(__MODULE__, &Kernel.map_size(&1))
  end

  @doc """
  Mines a new block in the blockchain.

  The transactions are added to the block and the block
  is added to the blockchain, after the block is mined.
  """
  @spec mine_block() :: :ok
  def mine_block() do
    data = BlockChain.Transactions.get_transactions()

    # Make merkle_tree TODO
    merkle_root = "TODO"

    # Mine the block

    # Add the block to the blockchain
    last_block = get_last_block()
    block = BlockChain.Block.new(1, last_block.header.merkle_root, merkle_root, data)

    add_block(block)
    BlockChain.Transactions.clear_transactions()
  end
end

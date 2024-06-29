defmodule BlockChain do
  use Agent

  @moduledoc """
  Documentation for `BlockChain`.
  """

  @doc """
  Starts the BlockChain Agent.
  """
  @spec start_link([any]) :: {:ok, String.t()} | {:error, term}
  def start_link(_opts) do
    {:ok, _pid} = Agent.start_link(fn -> %{} end, name: __MODULE__)
    :ok = genesis_block()
    {:ok, "BlockChain Agent started"}
  end

  # Genesis block for the BlockChain.
  # The genesis is the first block in the blockchain.
  # It is a special block that is hard coded and does not
  # reference a previous block.
  @spec genesis_block() :: :ok
  defp genesis_block() do
    block =
      Block.new(1, "0", [
        %Block.Data{
          from: "Vincenzo Marco",
          to: "Giovanni",
          value: 50
        }
      ])

    :ok = Agent.update(__MODULE__, &Map.put(&1, 1, block))
    add_block(1, [])
  end

  @doc """
  Adds a new block to the blockchain.

  ## Parameters
  - `version`: The version of the block.
  - `data`: The data that is stored in the block.
  """
  @spec add_block(integer, [%Block.Data{}]) :: :ok
  def add_block(version, data) do
    count = get_block_count()
    last_block = get_last_block()
    hash = block_hash(last_block)

    block = Block.new(version, hash, data)
    Agent.update(__MODULE__, &Map.put(&1, count + 1, block))
  end

  @doc """
  Gets a block from the blockchain.

  ## Parameters
  - `id`: The id of the block.
  """
  @spec get_block(integer) :: %Block{}
  def get_block(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  @doc """
  Gets the last block from the blockchain.
  """
  @spec get_last_block() :: %Block{}
  def get_last_block() do
    count = get_block_count()
    get_block(count)
  end

  @doc """
  Gets all blocks from the blockchain.
  """
  @spec get_blocks() :: [Block.t()]
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

  # TODO: Implement the merkle tree
  defp block_hash(block) do
    block.data
    |> Enum.map(&String.Chars.to_string(&1))
    |> Enum.join()
    |> (&:crypto.hash(:sha256, &1)).()
    |> Base.encode16()
  end

  @doc """
  Adds a new transaction to the last block in the blockchain.
  """
  @spec add_transaction(%Transaction{}) :: :ok
  def add_transaction(transaction) do
    count = get_block_count()
    Agent.update(__MODULE__, &Map.update(&1, count, [], fn map -> Block.add_transaction(map, transaction) end))
    :ok
  end

end

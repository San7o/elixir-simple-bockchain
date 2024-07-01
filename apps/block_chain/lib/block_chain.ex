defmodule BlockChain do
  use Agent
  import Bitwise
  require Logger

  # The number of leading zeros in the hash in bytes.
  @difficulty BlockChain.Constants.difficulty()
  @version BlockChain.Constants.version()

  @moduledoc """
  Documentation for `BlockChain`.
  """

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
    Logger.debug "Creating genesis block"
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
      0 -> BlockChain.Block.new(@version, "0", "0", 1, 0, [])
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
    merkle_tree = save_merkle_tree(data)

    last_block = get_last_block()
    block = BlockChain.Block.new(1, last_block.header.merkle_root, merkle_tree.value, @difficulty, 0, data)
    Logger.debug "Mining block"
    target = target(@difficulty)
    nonce = find_nonce(block.header, target)
    Logger.debug "Nonce: #{nonce}"
    block = %BlockChain.Block{block | header: %BlockChain.Block.Header{block.header | nonce: nonce}}

    add_block(block)
    BlockChain.Transactions.clear_transactions()
  end

  @spec save_merkle_tree([%BlockChain.Transaction{}]) :: :ok
  defp save_merkle_tree(data) do
    processed_data = data |> Enum.map(&BlockChain.Transaction.hash/1)
    merkle_tree = MerkleTree.build(processed_data)
    BlockChain.MerkleTreeStore.add(merkle_tree)
    merkle_tree
  end

  defp find_nonce(header, target) do
    #Logger.debug "Nonce: #{header.nonce}"
    if BlockChain.Block.Header.hash(header) < target do
      header.nonce
    else
      find_nonce(%BlockChain.Block.Header{header | nonce: header.nonce + 1}, target)
    end
  end

  @spec target(integer) :: float
  defp target(bits) do
    1 <<< 256 - bits*8
  end

  @doc """
  Veryfy a transaction in a block.

  ## Parameters
  - `block_id`: The id of the block.
  - `transaction_index`: The index of the transaction in the block data.
  """
  @spec verify_transaction(block_id :: integer, transaction_index :: integer) :: boolean
  def verify_transaction(block_id, transaction_index) do
    block = get_block(block_id)
    hashed_transaction = block.data
                  |> Enum.at(transaction_index)
                  |> BlockChain.Transaction.hash()
    merkle_tree = BlockChain.MerkleTreeStore.get_merkle_tree(block.header.merkle_root)

    proof = MerkleTree.Proof.prove(merkle_tree, transaction_index)
    MerkleTree.Proof.proven?({hashed_transaction, transaction_index}, merkle_tree.value, &MerkleTree.Crypto.sha256/1, proof)
  end

  @doc """
  Verify a block.
  """
  @spec verify_block(block_id :: integer) :: boolean
  def verify_block(block_id) do
    block = get_block(block_id)
    BlockChain.Block.Header.hash(block.header) < target(block.header.difficulty)
  end
end

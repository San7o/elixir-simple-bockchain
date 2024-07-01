# elixir-simple-blockchain

## Project Statement

This project aims to create a simple block chain in elixir. This project is directly
inspired by Bitcoin.


### Current state
The project is just a minimum viable product, It does not fully implement the P2P network
and It doesn't aim to be run in any production. What has been implemented is:

- [x] Blockchain

- [x] Transactions

- [x] Wallets

- [x] Merkle Tree

- [x] Proof of Work

- [x] Transaction & Block validation

- [x] Broadcasting

The application is divided into:

- `apps/block_chain`: the blockchain logic, stable

- `apps/bc_node`: the node peer, currently under developement

## Requirements

You need Elixir and Erlang installed. If you are on NixOS, you can enter the
developement environment with
```bash
nix develop
```

You might need to install required depenencies with:
```bash
mix deps.get
```

To run tests, use the following command inside `apps/block_chain/`
```bash
mix test
```

# Usage

## Node

To run the peer node, use the command:
```bash
mix run
```
If you want multiple nodes on the same machine, you can specify the `TCP_PORT` environment variable:
```bash
TCP_PORT=1234 mix run
```

By default, the node listens on TCP for commands on port `49999` and listens on broadcast from the other peers in `49998`. To issue commands, you can connect with `netcat` or any other telnet client:
```bash
nc localhost 49999
```
You can then interact with the following commands:
```
node> WALLET HELP
 - WALLET NEW <name> - Create a new wallet
 - WALLET SHOW <name> - Show wallet
 - WALLET LIST - List wallets
node> TRANSACTION HELP
 - TRANSACTION NEW <from-wallet> <to-public-key> <amount> - Create a new transaction
 - TRANSACTION LIST - List transactions
node> BLOCKCHAIN HELP
 - BLOCKCHAIN SHOW - Show blockchain
 - BLOCKCHAIN MINE - Mine a new block
 - BLOCKCHAIN VERIFY BLOCK <block-id> - Verify a block
 - BLOCKCHAIN VERIFY TRANSACTION <block-id> <transaction-index> - Verify a transaction
node>
```

## Library examples

To acces the `BlockChain` library, enter in interactive mode inside `apps/block_chain/`:
```bash
iex -S mix
```

First you need to create a wallet with `BlockChain.Wallet`
```elixir
iex> wallet = BlockChain.Wallet.new()
%BlockChain.Wallet{
  transactions: [],
  private_key: "EA7A08635937EC89A4B693AC9F47493DDD4C481C5DA884B04A34787719A42724",
  public_key: "045AD110FD07045BC9C7D38329283DC18EE07BC476CE477122D8130F2639ADB773CFF925F80C1CBB94B5DD7B7A135ED34DFD262E6433B5FC1BBB906AC71BACC9DD"
  }
```
You can create a transaction with `BlockChain.Transaction`
```elixir
iex> transaction = BlockChain.Transaction.new(wallet.public_key, receiver_public_key, 10)
%BlockChain.Transaction{
  from: "045AD110FD07045BC9C7D38329283DC18EE07BC476CE477122D8130F2639ADB773CFF925F80C1CBB94B5DD7B7A135ED34DFD262E6433B5FC1BBB906AC71BACC9DD",
  to: "04A26948A1CB444CF11734A0F01386DB45FCE700E74707CF9B560A6EACC8170A9E6204EEBCD19D9FF46C8E7337FF84311AB5621EC64E43C837AF2056B6795E3AFA",
  amount: 10
}
```

And you can register the transaction in the transactions pool
```elixir
iex> wallet = BlockChain.Transactions.add_transaction(wallet, transaction)
```

Check all the transactions ready to be mined from the pool
```elixir
iex> BlockChain.Transactions.get_transactions()
```

Mine those transactions:
```elixir
iex> BlockChain.mine_block()
:ok
```

Now the block has been mined and has been added to the blockchain.

You can check the block chain with:
```elixir
iex> BlockChain.get_blocks()
iex> BlockChain.get_block(id)
iex> BlockChain.get_last_block()
```

Verify a transaction on a block:
```elixir
iex> BlockChain.verify_transaction(block_id, transaction_index)
```

Verify a block in the block chain:
```elixir
iex> BlockChain.verify_block(block_id)
```

# Simple implementation

```elixir
defmodule BlockChain do
  use Application
  use Agent
  import Bitwise
  require Logger

  # The number of leading zeros in the hash in bytes.
  @difficulty 2
  @version 1

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
```

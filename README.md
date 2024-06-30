# elixir-simple-blockchain

## Project Statement

This project aims to create a simple block chain in elixir. This project is directly
inspired by the Bitcoin Protocol specification.

Currently the project is under heavy developement and is changing rapidly, do
not use this code anywhere.

## Requirements

You need Elixir and Erlang installed. If you are on NixOS, you can enter the
developement environment with
```bash
nix develop
```

# Usage

Enter in interactive mode:
```bash
iex -S mix
```

First you need to create a wallet with `BlockChain.Wallet`
```elixir
iex> wallet = BlockChain.Wallet.new()
%BlockChain.Wallet{
  transactions: [],
  private_key: <<221, 106, 154, 35, 201, 81, 115, 176, 247, 29, 45, 33, 67, 94,
    97, 192, 214, 101, 28, 125, 113, 23, 203, 124, 182, 184, 171, 217, 35, 21,
    111, 69>>,
  public_key: <<4, 152, 36, 193, 156, 164, 226, 168, 118, 133, 175, 29, 184, 80,
    124, 120, 105, 118, 227, 83, 106, 49, 155, 23, 221, 19, 127, 177, 117, 126,
    123, 112, 215, 206, 81, 215, 85, 141, 109, 157, 82, 178, 254, 76, 16, 49,
    16, ...>>
}
```
You create a transaction with `BlockChain.Transaction`
```elixir
iex> transaction = BlockChain.Transaction.new(wallet, receiver_public_key, 10)
%BlockChain.Transaction{
  from: %BlockChain.Wallet{
    transactions: [],
    private_key: <<221, 106, 154, 35, 201, 81, 115, 176, 247, 29, 45, 33, 67,
      94, 97, 192, 214, 101, 28, 125, 113, 23, 203, 124, 182, 184, 171, 217, 35,
      21, 111, 69>>,
    public_key: <<4, 152, 36, 193, 156, 164, 226, 168, 118, 133, 175, 29, 184,
      80, 124, 120, 105, 118, 227, 83, 106, 49, 155, 23, 221, 19, 127, 177, 117,
      126, 123, 112, 215, 206, 81, 215, 85, 141, 109, 157, 82, 178, 254, 76, 16,
      49, ...>>
  },
  to: <<4, 240, 218, 96, 169, 237, 255, 60, 243, 147, 18, 124, 232, 157, 30, 58,
    20, 196, 42, 165, 37, 216, 39, 234, 226, 70, 98, 122, 151, 239, 236, 134,
    140, 218, 182, 55, 51, 25, 180, 132, 145, 0, 1, 96, 138, 7, 112, 102, ...>>,
  amount: 10
}
```

And you can register the transaction in the network
```elixir
iex> wallet = BlockChain.Transactions.add_transaction(wallet, transaction)
```

Check all the transactions ready to be mined
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

## Simple implementation

```elixir
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

  #Adds a new block to the blockchain.
  #
  ## Parameters
  #- `version`: The version of the block.
  #- `data`: The data that is stored in the block.
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
       0 ->  BlockChain.Block.new(1, "0", "0", [])
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
```

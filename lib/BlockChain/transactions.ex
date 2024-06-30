defmodule BlockChain.Transactions do
  use Agent

  @moduledoc """
  Documentation for `Transactions`.

  This module is responsible for saving all transactions that are not yet
  added to the blockchain as blocks.
  """

  @doc """
  Starts the Transactions Agent.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Add a new transaction in the blockchain and updates the wallet.

  ## Parameters
  - `wallet`: The wallet to save.
  - `transaction`: The transaction to save.

  Returns `:ok` if the transaction was saved successfully.
  """
  @spec add_transaction(%BlockChain.Wallet{}, %BlockChain.Transaction{}) :: :ok
  def add_transaction(wallet, transaction) do
    count = get_transaction_count()
    Agent.update(__MODULE__, &Map.put(&1, count + 1, transaction))
    BlockChain.Wallet.add_transaction(wallet, transaction)
  end

  @doc """
  Get the trascation count.

  Returns the number of transactions as an integer.
  """
  @spec get_transaction_count() :: integer
  def get_transaction_count() do
    Agent.get(__MODULE__, &Kernel.map_size(&1))
  end

  @doc """
  Clear all transactions from the agent.
  """
  @spec clear_transactions() :: :ok
  def clear_transactions() do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

  @doc """
  Get all transactions.

  Returns a list of all transactions not yet added to the blockchain.
  """
  @spec get_transactions() :: [%BlockChain.Transaction{}]
  def get_transactions() do
    Agent.get(__MODULE__, &Map.values(&1))
  end

end

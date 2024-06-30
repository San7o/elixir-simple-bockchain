defmodule BlockChain.Transaction do
  @moduledoc """
  Documentation for `Transaction`.
    
  A Transaction is a transfer of value between two wallets. This
  module is responsible for creating and hashing transactions,
  to add a transaction to the blockchain use `BlockChain.Transactions`
  """

  defstruct [:from, :to, :amount]

  @doc """
  Creates a new transaction and returns the updated wallet, adding
  the trasaction to the block chain.
  """
  @spec new(String.t(), String.t(), integer) :: %BlockChain.Wallet{}
  def new(from, to, amount) do
    %BlockChain.Transaction{
      from: from,
      to: to,
      amount: amount
    }
  end

  @doc """
  Get the hash of a transaction.
  """
  @spec hash(%BlockChain.Transaction{}) :: String.t()
  def hash(transaction) do
    :crypto.hash(:sha256, transaction |> Map.from_struct() |> Map.values() |> Enum.join())
    |> Base.encode16()
  end
end

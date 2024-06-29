defmodule Transaction do
   
  @moduledoc """
  Documentation for `Transaction`.
    
  A Transaction is a transfer of value between two wallets.
  """

  defstruct [:from, :to, :amount]

  @doc """
  Creates a new transaction and returns the updated wallet, adding
  the trasaction to the block chain.
  """
  @spec new_transaction(%Wallet{}, String.t, integer) :: %Wallet{}
  def new_transaction(from, to, amount) do
    transaction = %Transaction {
      from: from.public_key,
      to: to,
      amount: amount
    }
    BlockChain.add_transaction(transaction)

    Wallet.add_transaction(from, transaction)
  end

  @doc """
  Get the hash of a transaction.
  """
  @spec hash(%Transaction{}) :: String.t
  def hash(transaction) do
    :crypto.hash(:sha256, transaction |> Map.from_struct() |> Map.values() |> Enum.join()) |> Base.encode16()
  end

end

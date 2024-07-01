defmodule BlockChain.Wallet do
  @moduledoc """
  Documentation for `Wallet`.

  A Wallet is a digital wallet that contains a list 
  of transactions and a public and private key.
  """

  defstruct [:transactions, :private_key, :public_key]

  @doc """
  Creates a new wallet.
  """
  @spec new() :: %BlockChain.Wallet{}
  def new() do
    %BlockChain.Wallet{
      transactions: [],
      private_key: :crypto.generate_key(:ecdh, :secp256k1) |> elem(1) |> Base.encode16(),
      public_key: :crypto.generate_key(:ecdh, :secp256k1) |> elem(0) |> Base.encode16()
    }
  end

  @doc """
  Add a transaction to the wallet, without registering it in the blockchain.
  Do not call this method directly, use `BlockChain.Transaction.new/3` instead.

  ## Parameters
  - `wallet`: The wallet to add the transaction to.
  - `transaction`: The transaction to add.
  """
  @spec add_transaction(%BlockChain.Wallet{}, %BlockChain.Transaction{}) :: %BlockChain.Wallet{}
  def add_transaction(wallet, transaction) do
    %BlockChain.Wallet{
      wallet
      | transactions: [transaction | wallet.transactions]
    }
  end

  @doc """
  Get the balance of the wallet.

  ## Parameters
  - `wallet`: The wallet to get the balance of.
  """
  @spec balance(%BlockChain.Wallet{}) :: integer
  def balance(wallet) do
    wallet.transactions
    |> Enum.reduce(0, fn transaction, acc ->
      if transaction.from == wallet.public_key do
        acc - transaction.amount
      else
        acc + transaction.amount
      end
    end)
  end
end

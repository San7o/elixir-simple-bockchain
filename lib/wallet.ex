defmodule Wallet do

  @moduledoc """
  Documentation for `Wallet`.

  A Wallet is a digital wallet that contains a list 
  of transactions and a public and private key.
  """

  defstruct [:transactions, :private_key, :public_key]

  @doc """
  Creates a new wallet.
  """
  @spec new() :: %Wallet{}
  def new() do
    %Wallet{
      transactions: [],
      private_key: :crypto.generate_key(:ecdh, :secp256k1) |> elem(1),
      public_key: :crypto.generate_key(:ecdh, :secp256k1) |> elem(0)
    }
  end

  @doc """
  Add a transaction to the wallet.
  """
  @spec add_transaction(%Wallet{}, %Transaction{}) :: %Wallet{}
  def add_transaction(wallet, transaction) do
    %Wallet{
      wallet | transactions: [transaction | wallet.transactions]
    }
  end

  @doc """
  Get the balance of the wallet.
  """
  @spec balance(%Wallet{}) :: integer
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

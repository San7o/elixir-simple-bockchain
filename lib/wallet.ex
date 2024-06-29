defmodule Wallet do

  @moduledoc """
  Documentation for `Wallet`.

  A Wallet is a digital wallet that contains a
  balance and a list of transactions.
  """

  defstruct [:balance, :transactions, :private_key, :public_key]

  @doc """
  Creates a new wallet.
  """
  @spec new() :: %Wallet{}
  def new() do
    %Wallet{
      balance: 0,
      transactions: [],
      private_key: :crypto.generate_key(:ecdh, :secp256k1) |> elem(1),
      public_key: :crypto.generate_key(:ecdh, :secp256k1) |> elem(0)
    }
  end

end

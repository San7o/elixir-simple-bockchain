defmodule BcNode.Wallets do
  use Agent

  @moduledoc """
  Wrapper arount Agent to store wallets.
  """

  @spec start_link([any]) :: {:ok, String.t()} | {:error, term}
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec new_wallet(String.t()) :: :ok
  def new_wallet(name) do
    wallet = BlockChain.Wallet.new()
    Agent.update(__MODULE__, &Map.put(&1, name, wallet))
  end

  @spec get_wallet(String.t()) :: %BlockChain.Wallet{}
  def get_wallet(name) do
    Agent.get(__MODULE__, &Map.get(&1, name))
  end

  @spec get_wallets() :: [String.t()]
  def get_wallets() do
    Agent.get(__MODULE__, &Map.keys/1)
  end

  @spec add_transaction(%BlockChain.Wallet{}, %BlockChain.Transaction{}) :: :ok
  def add_transaction(name, transaction) do
    Agent.update(
      __MODULE__,
      &Map.update!(&1, name, fn wallet ->
        BlockChain.Wallet.add_transaction(wallet, transaction)
      end)
    )
  end
end

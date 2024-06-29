defmodule WalletTest do
  use ExUnit.Case

  setup do
    {:ok, _term} = BlockChain.start_link([])
    :ok
  end

  test "create a new wallet" do
    wallet = Wallet.new()
    assert Kernel.length(wallet.transactions) == 0
  end

  test "the balance of a wallet" do
    wallet = Wallet.new()
    wallet = Transaction.new_transaction(wallet, "Giovanni", 10)
    assert Wallet.balance(wallet) == -10
  end

end

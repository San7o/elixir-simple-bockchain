defmodule BlockChain.WalletTest do
  use ExUnit.Case

  test "create a new wallet" do
    wallet = BlockChain.Wallet.new()
    assert Kernel.length(wallet.transactions) == 0
  end

  test "the balance of a wallet" do
    wallet1 = BlockChain.Wallet.new()
    wallet2 = BlockChain.Wallet.new()
    transaction = BlockChain.Transaction.new(wallet1.public_key, wallet2.public_key, 10)
    wallet = BlockChain.Transactions.add_transaction(wallet1, transaction)
    assert BlockChain.Wallet.balance(wallet) == -10
  end

end

defmodule BlockChain.TransactionsTest do
  use ExUnit.Case

  @moduletag :capture_log
  setup do
    Application.stop(:block_chain)
    Application.start(:block_chain)
  end

  test "add a transaction, get and clear" do
    wallet1 = BlockChain.Wallet.new()
    wallet2 = BlockChain.Wallet.new()
    transaction = BlockChain.Transaction.new(wallet1.public_key, wallet2.public_key, 1337)
    wallet1 = BlockChain.Transactions.add_transaction(wallet1, transaction)
    assert wallet1.transactions == [transaction]

    transactions = BlockChain.Transactions.get_transactions()
    assert transactions == [transaction]

    BlockChain.Transactions.clear_transactions()
    transactions = BlockChain.Transactions.get_transactions()
    assert transactions == []
  end

end

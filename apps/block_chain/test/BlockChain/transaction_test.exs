defmodule BlockChain.TransactionTest do
  use ExUnit.Case

  @moduletag :capture_log
  setup do
    Application.stop(:block_chain)
    Application.start(:block_chain)
  end

  test "create a new transaction" do
    transaction = BlockChain.Transaction.new("gio", "Giovanni", 10)
    assert transaction.from == "gio"
    assert transaction.to == "Giovanni"
    assert transaction.amount == 10
  end

  test "get the hash of a transaction" do
    transaction = %BlockChain.Transaction{from: "Test1", to: "Test2", amount: 30}
    hash = BlockChain.Transaction.hash(transaction)
    assert hash == "7C59E5D7960DE086735EEC729B42ECBF9BA319DA72C16ADE4E8BEA912344A28C"
  end

  test "is transaction" do
    transaction = %BlockChain.Transaction{from: "Test1", to: "Test2", amount: 30}
    assert BlockChain.Transaction.is_transaction(transaction) == true

    transaction = %{}
    assert BlockChain.Transaction.is_transaction(transaction) == false

    transaction = 1
    assert BlockChain.Transaction.is_transaction(transaction) == false
  end
end

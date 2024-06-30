defmodule BlockChainTest do
  use ExUnit.Case

  @moduletag :capture_log
  setup do
    Application.stop(:block_chain)
    Application.start(:block_chain)
  end

  test "get block genesis" do
    block = BlockChain.get_block(1)
    assert block.header.version == 1
    assert block.header.prev_block == "0"
    assert Kernel.length(block.data) == 1
  end

  test "get last block (genesis)" do
    block = BlockChain.get_last_block()
    assert block.header.version == 1
    assert block.header.prev_block == "0"
    assert Kernel.length(block.data) == 1
  end

  test "get block count" do
    count = BlockChain.get_block_count()
    assert count == 1
  end

  test "get all blocks in the blockchain" do
    blocks = BlockChain.get_blocks()
    assert Enum.count(blocks) == 1
  end

  test "mine a new block" do
    transaction = BlockChain.Transaction.new("Vincenzo Marco", "Giovanni", 50)
    wallet = BlockChain.Wallet.new()
    _wallet = BlockChain.Transactions.add_transaction(wallet, transaction)

    assert :ok == BlockChain.mine_block()

    count = BlockChain.get_block_count()
    assert count == 2

    block = BlockChain.get_block(2)
    assert block.header.version == 1

    assert block.data == [
             %BlockChain.Transaction{from: "Vincenzo Marco", to: "Giovanni", amount: 50}
           ]
  end

  test "verify transaction" do
    wallet1 = BlockChain.Wallet.new()
    wallet2 = BlockChain.Wallet.new()
    transaction = BlockChain.Transaction.new(wallet1.public_key, wallet2.public_key, 1337)
    wallet1 = BlockChain.Transactions.add_transaction(wallet1, transaction)
    assert wallet1.transactions == [transaction]
    assert :ok == BlockChain.mine_block()
    assert BlockChain.verify_transaction(2, 0) == true
  end

  test "verify block" do
    transaction = BlockChain.Transaction.new("Vincenzo Marco", "Giovanni", 50)
    wallet = BlockChain.Wallet.new()
    _wallet = BlockChain.Transactions.add_transaction(wallet, transaction)
    assert :ok == BlockChain.mine_block()
    assert BlockChain.verify_block(2) == true
  end
end

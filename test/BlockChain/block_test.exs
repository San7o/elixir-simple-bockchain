defmodule BlockChain.BlockTest do
  use ExUnit.Case

  test "create a new block" do
    block = BlockChain.Block.new(1, "0", "0", [%BlockChain.Transaction{from: "Test1", to: "Test2", amount: 30}])
    assert block.header.version == 1
    assert block.header.prev_block == "0"
    assert block.header.merkle_root == "0"
    assert block.data == [%BlockChain.Transaction{from: "Test1", to: "Test2", amount: 30}]
  end
end

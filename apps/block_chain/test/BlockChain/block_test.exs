defmodule BlockChain.BlockTest do
  use ExUnit.Case

  test "create a new block" do
    block =
      BlockChain.Block.new(1, "0", "0", 1, 0, [
        %BlockChain.Transaction{from: "Test1", to: "Test2", amount: 30}
      ])

    assert block.header.version == 1
    assert block.header.prev_block == "0"
    assert block.header.merkle_root == "0"
    assert block.data == [%BlockChain.Transaction{from: "Test1", to: "Test2", amount: 30}]
  end

  test "is block" do
    block = {}
    assert BlockChain.Block.is_block(block) == false

    block = 1
    assert BlockChain.Block.is_block(block) == false

    block = %{}
    assert BlockChain.Block.is_block(block) == false

    block = %BlockChain.Block{}
    assert BlockChain.Block.is_block(block) == true
  end
end

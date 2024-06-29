defmodule BlockChainTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, _term} = BlockChain.start_link([])
    :ok
  end
  
  test "get block genesis" do
    block = BlockChain.get_block(1)
    assert block.data == "Genesis Block"
  end

  test "get last block" do
    block = BlockChain.get_last_block()
    assert block.data == "Genesis Block"
  end

  test "get block count" do
    count = BlockChain.get_block_count()
    assert count == 1
  end

  test "add a new block to the blockchain" do
    assert :ok == BlockChain.add_block(1, "Some Data")
  end

end

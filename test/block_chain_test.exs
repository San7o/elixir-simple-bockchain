defmodule BlockChainTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, _term} = BlockChain.start_link([])
    :ok
  end

  test "get block genesis" do
    block = BlockChain.get_block(1)
    assert block.header.version == 1
    assert block.header.prev_block == "0"
    assert block.data == [%Block.Data{from: "Vincenzo Marco", to: "Giovanni", value: 50}]
  end

  test "get last block" do
    block = BlockChain.get_last_block()
    assert block.header.version == 1
    assert block.header.prev_block == "83A6A53E6901EDD9410C2175E5EEDEBBE3B53204F059D24EAFAC3D5F8E36C143"
    assert block.data == []
  end

  test "get block count" do
    count = BlockChain.get_block_count()
    assert count == 2
  end

  test "add a new block to the blockchain" do
    data = [%Block.Data{from: "Test1", to: "Test2", value: 30}]
    assert :ok == BlockChain.add_block(1, data)
  end
end

defmodule Blockest do
  use ExUnit.Case

  test "create a new block" do
    block = Block.new(1, "0", [%Block.Data{from: "Test1", to: "Test2", value: 30}])
    assert block.header.version == 1
    assert block.header.prev_block == "0"
    assert block.data == [%Block.Data{from: "Test1", to: "Test2", value: 30}]
  end
end

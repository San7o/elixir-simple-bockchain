defmodule Blockest do
  use ExUnit.Case

  test "create a new block" do
    block = Block.new(1, "0", "Some Data")
    assert block.header.version == 1
    assert block.header.prev_block == "0"
    assert block.data == "Some Data"
  end

end

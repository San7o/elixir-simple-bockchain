defmodule BlockChainTest do
  use ExUnit.Case
  doctest BlockChain

  test "greets the world" do
    assert BlockChain.hello() == :world
  end
end

defmodule BlockChain.MerkleTreeStoreTest do
  use ExUnit.Case

  test "add a merkle tree, get" do
    merkle_tree = MerkleTree.build(["a", "b", "c", "d"])
    BlockChain.MerkleTreeStore.add(merkle_tree)
    assert BlockChain.MerkleTreeStore.get_merkle_tree(merkle_tree.value) == merkle_tree
  end
end

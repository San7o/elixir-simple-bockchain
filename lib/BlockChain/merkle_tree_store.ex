defmodule BlockChain.MerkleTreeStore do
  use Agent

  @moduledoc """
  Documentation for `BlockChain.MerkleTreeStore`.
  """

  @doc """
  Starts the BlockChain Agent.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Adds a new merkle tree to the store.
  """
  @spec add(%MerkleTree{}) :: :ok
  def add(merkle_tree) do
    Agent.update(__MODULE__, &Map.put(&1, merkle_tree.value, merkle_tree))
  end

  @doc """
  Gets a merkle tree from the store.

  ## Parameters
  - `root`: The root of the merkle tree.
  """
  @spec get_merkle_tree(String.t()) :: %MerkleTree{}
  def get_merkle_tree(root) do
    Agent.get(__MODULE__, &Map.get(&1, root))
  end

end

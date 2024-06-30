defmodule BlockChain.Block.Header do
  @moduledoc """
  Documentation for `Header`.

  A Header is the metadata of a block. It contains the following 
  informations about the block:
  - version: The version of the block.
  - prev_block: The hash of the previous block.
  - merkle_root: The root of the merkle tree of transactions.
  - timestamp: The time the block was created.
  - difficulty: The difficulty of the block.
  - nonce: The nonce of the block that when hashed with the block
    header, the hash is less than the target.
  """

  defstruct [:version, :prev_block, :merkle_root, :timestamp, :difficulty, :nonce]

  @spec hash(%BlockChain.Block.Header{}) :: integer
  def hash(header) do
    :crypto.hash(:sha256, header |> Map.from_struct() |> Map.values() |> Enum.join()) |> :binary.decode_unsigned()
  end
end

defimpl String.Chars, for: BlockChain.Block.Header do
  def to_string(header) do
    """
    Version: #{header.version}
    Previous Block: #{header.prev_block}
    Merkle Root: #{header.merkle_root}
    Timestamp: #{header.timestamp}
    Difficulty: #{header.difficulty}
    Nonce: #{header.nonce}
    """
  end
end

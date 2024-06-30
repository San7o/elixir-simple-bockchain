defmodule BlockChain.Block.Header do
  @moduledoc """
  Documentation for `Header`.

  A Header is the metadata of a block. It contains the following 
  informations about the block:
  - version: The version of the block.
  - prev_block: The hash of the previous block.
  - merkle_root: The root of the merkle tree of transactions.
  - timestamp: The time the block was created.
  - ntnx_count: The number of transactions in the block.
  """

  defstruct [:version, :prev_block, :merkle_root, :timestamp, :ntnx_count]
end

defimpl String.Chars, for: BlockChain.Block.Header do
  def to_string(header) do
    """
    Version: #{header.version}
    Previous Block: #{header.prev_block}
    Merkle Root: #{header.merkle_root}
    Timestamp: #{header.timestamp}
    Number of Transactions: #{header.ntnx_count}
    """
  end
end

defmodule Block do

  @moduledoc """
  Documentation for `Block`.

  A Block is the basic unit of a blockchain. It contains a header
  and data. The header contains metadata about the block and the
  data contains the actual information that is stored in the block.
  More specifically:

  ## Header
  - version: The version of the block.
  - prev_block: The hash of the previous block.
  - merkle_root: The root of the merkle tree of transactions.
  - timestamp: The time the block was created.
  - ntnx_count: The number of transactions in the block.


  ## Data
  - data: The actual information that is stored in the block.
  

  This is an implementation of the BitCoin block, for more information see [here](https://en.bitcoin.it/wiki/Protocol_documentation#Block_Headers).
  """

  defstruct [:header, :data]

  @doc """
  Creates a new block.

  ## Parameters
  - `version`: The version of the block.
  - `prev_block`: The hash of the previous block.
  - `data`: The data that is stored in the block.
  """
  @spec new(version :: integer, prev_block :: String.t, data :: String.t) :: %Block{}
  def new(version, prev_block, data) do
    %Block{
      header: %Block.Header{
        version: version,
        prev_block: prev_block,
        merkle_root: "TODO",
        timestamp: DateTime.utc_now() |> DateTime.to_unix(),
        ntnx_count: 1
      },
      data: data
    }
  end

end

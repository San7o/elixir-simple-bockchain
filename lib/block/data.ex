defmodule Block.Data do
  @moduledoc """
  Documentation for `Block.Data`.

  A BlockData is the data of a block. It contains the following
  informations about the block:
  - from: The sender of the block.
  - to: The receiver of the block.
  - value: The value of the block.
  """

  defstruct [:from, :to, :value]
end

defimpl String.Chars, for: Block.Data do
  def to_string(data) do
    """
    From: #{data.from}
    To: #{data.to}
    Value: #{data.value}
    """
  end
end

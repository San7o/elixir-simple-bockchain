defmodule BlockChain.Constants do

  @doc """
  The number of leading zeros in the hash of a sha256 in bytes.
  """
  def difficulty do
    2
  end

  @doc """
  The version of the blockchain.
  """
  def version do
    1
  end

end

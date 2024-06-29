defmodule WalletTest do
  use ExUnit.Case, async: true

  test "create a new wallet" do
    wallet = Wallet.new()
    assert wallet.balance == 0
  end

end

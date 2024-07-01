defmodule BcNode.WalletsTest do
  use ExUnit.Case

  setup do
    Application.stop(:bc_node)
    :ok = Application.start(:bc_node)
  end

  test "new_wallet" do
    assert BcNode.Wallets.new_wallet("test")
  end

  test "get_wallet" do
    BcNode.Wallets.new_wallet("test")
    assert %BlockChain.Wallet{} = BcNode.Wallets.get_wallet("test")
  end

  test "get_wallets" do
    BcNode.Wallets.new_wallet("test")
    assert ["test"] = BcNode.Wallets.get_wallets()
  end

  test "add_transaction" do
    BcNode.Wallets.new_wallet("test")
    transaction = %BlockChain.Transaction{from: "test", to: "test", amount: 1}
    assert :ok = BcNode.Wallets.add_transaction("test", transaction)
  end
end

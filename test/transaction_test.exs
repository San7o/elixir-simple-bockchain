defmodule TransactionTest do
  use ExUnit.Case

  setup do
    {:ok, _term} = BlockChain.start_link([])
    :ok
  end

  test "create a new transaction" do
    wallet = Wallet.new()
    assert Kernel.length(wallet.transactions) == 0
    assert Kernel.length(BlockChain.get_last_block().data) == 0

    wallet = Transaction.new_transaction(wallet, "Giovanni", 10)
    assert Kernel.length(wallet.transactions) == 1
    assert wallet == %Wallet{
      transactions: [
        %Transaction{
          from: wallet.public_key,
          to: "Giovanni",
          amount: 10}],
      private_key: wallet.private_key,
      public_key: wallet.public_key
    }

    block = BlockChain.get_last_block()
    assert Kernel.length(block.data) == 1
  end

  test "get the hash of a transaction" do
    transaction = %Transaction{from: "Test1", to: "Test2", amount: 30}
    hash = Transaction.hash(transaction)
    assert hash == "7C59E5D7960DE086735EEC729B42ECBF9BA319DA72C16ADE4E8BEA912344A28C"
  end
end

defmodule BcNode.Command do
  require Logger

  def parse(line) do
    case String.split(line) do
      ["WALLET", "HELP"] ->
        {:ok, {:help_wallet}}

      ["WALLET", "NEW", name] ->
        {:ok, {:new_wallet, name}}

      ["WALLET", "SHOW", name] ->
        {:ok, {:show_wallet, name}}

      ["WALLET", "LIST"] ->
        {:ok, {:list_wallets}}

      ["TRANSACTION", "HELP"] ->
        {:ok, {:help_transaction}}

      ["TRANSACTION", "NEW", from, to, amount] ->
        {:ok, {:new_transaction, from, to, amount}}

      ["TRANSACTION", "LIST"] ->
        {:ok, {:list_transactions}}

      ["BLOCKCHAIN", "HELP"] ->
        {:ok, {:help_blockchain}}

      ["BLOCKCHAIN", "SHOW"] ->
        {:ok, {:show_blockchain}}

      ["BLOCKCHAIN", "MINE"] ->
        {:ok, {:mine_blockchain}}

      ["BLOCKCHAIN", "VERIFY", "BLOCK", block_id] ->
        {:ok, {:verify_block, block_id}}

      ["BLOCKCHAIN", "VERIFY", "TRANSACTION", block_id, transaction_index] ->
        {:ok, {:verify_transaction, block_id, transaction_index}}

      _ ->
        {:error, :unknown_command}
    end
  end

  def run(command)

  def run({:help_wallet}) do
    {:ok,
     " - WALLET NEW <name> - Create a new wallet\n - WALLET SHOW <name> - Show wallet\n - WALLET LIST - List wallets\n"}
  end

  def run({:new_wallet, name}) do
    :ok = BcNode.Wallets.new_wallet(name)
    {:ok, "OK\n"}
  end

  def run({:show_wallet, wallet}) do
    wallet = BcNode.Wallets.get_wallet(wallet)
    {:ok, "Wallet: #{inspect(wallet, pretty: true)}\n"}
  end

  def run({:list_wallets}) do
    wallets = BcNode.Wallets.get_wallets()
    {:ok, "Wallets: #{inspect(wallets, pretty: true)}\n"}
  end

  def run({:help_transaction}) do
    {:ok,
     " - TRANSACTION NEW <from-wallet> <to-public-key> <amount> - Create a new transaction\n - TRANSACTION LIST - List transactions\n"}
  end

  def run({:new_transaction, from, to, amount}) do
    from_wallet = BcNode.Wallets.get_wallet(from)
    transaction = BlockChain.Transaction.new(from_wallet.public_key, to, amount)
    _wallet = BlockChain.Transactions.add_transaction(from_wallet, transaction)
    BcNode.Wallets.add_transaction(from, transaction)
    {:ok, "OK\n"}
  end

  def run({:list_transactions}) do
    transactions = BlockChain.Transactions.get_transactions()
    {:ok, "Transactions: #{inspect(transactions, pretty: true)}\n"}
  end

  def run({:help_blockchain}) do
    {:ok,
     " - BLOCKCHAIN SHOW - Show blockchain\n - BLOCKCHAIN MINE - Mine a new block\n - BLOCKCHAIN VERIFY BLOCK <block-id> - Verify a block\n - BLOCKCHAIN VERIFY TRANSACTION <block-id> <transaction-index> - Verify a transaction\n"}
  end

  def run({:show_blockchain}) do
    blockchain = BlockChain.get_blocks()
    {:ok, "Blockchain: #{inspect(blockchain, pretty: true)}\n"}
  end

  def run({:mine_blockchain}) do
    BlockChain.mine_block()
    {:ok, "OK\n"}
  end

  def run({:verify_block, block_id}) do
    Logger.debug("Verifying block #{block_id}")

    case BlockChain.verify_block(String.to_integer(block_id)) do
      true -> {:ok, "Block is valid\n"}
      false -> {:ok, "Block is invalid\n"}
    end
  end

  def run({:verify_transaction, block_id, transaction_index}) do
    case BlockChain.verify_transaction(
           String.to_integer(block_id),
           String.to_integer(transaction_index)
         ) do
      true -> {:ok, "Transaction is valid\n"}
      false -> {:ok, "Transaction is invalid\n"}
    end
  end
end

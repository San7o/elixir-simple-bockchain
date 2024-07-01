searchData={"content_type":"text/markdown","items":[{"doc":"Documentation for `BlockChain`.","ref":"BlockChain.html","title":"BlockChain","type":"module"},{"doc":"Returns a specification to start this module under a supervisor.\n\nSee `Supervisor`.","ref":"BlockChain.html#child_spec/1","title":"BlockChain.child_spec/1","type":"function"},{"doc":"Gets a block from the blockchain.","ref":"BlockChain.html#get_block/1","title":"BlockChain.get_block/1","type":"function"},{"doc":"- `id`: The id of the block.","ref":"BlockChain.html#get_block/1-parameters","title":"Parameters - BlockChain.get_block/1","type":"function"},{"doc":"Gets the number of blocks in the blockchain.","ref":"BlockChain.html#get_block_count/0","title":"BlockChain.get_block_count/0","type":"function"},{"doc":"Gets all blocks from the blockchain.","ref":"BlockChain.html#get_blocks/0","title":"BlockChain.get_blocks/0","type":"function"},{"doc":"Gets the last block from the blockchain.","ref":"BlockChain.html#get_last_block/0","title":"BlockChain.get_last_block/0","type":"function"},{"doc":"Mines a new block in the blockchain.\n\nThe transactions are added to the block and the block\nis added to the blockchain, after the block is mined.","ref":"BlockChain.html#mine_block/0","title":"BlockChain.mine_block/0","type":"function"},{"doc":"Starts the BlockChain Agent.","ref":"BlockChain.html#start_link/1","title":"BlockChain.start_link/1","type":"function"},{"doc":"The application callback module.\nStarts the Transactions and BlockChain processes as\nsupervised processes.","ref":"BlockChain.Application.html","title":"BlockChain.Application","type":"module"},{"doc":"Documentation for `Block`.\n\nA Block is the basic unit of a blockchain. It contains a header\nand data. The header contains metadata about the block and the\ndata contains the actual information that is stored in the block.\nMore specifically:","ref":"BlockChain.Block.html","title":"BlockChain.Block","type":"module"},{"doc":"- version: The version of the block.\n- prev_block: The hash of the previous block.\n- merkle_root: The root of the merkle tree of transactions.\n- timestamp: The time the block was created.\n- ntnx_count: The number of transactions in the block.","ref":"BlockChain.Block.html#module-header","title":"Header - BlockChain.Block","type":"module"},{"doc":"- data: The actual information that is stored in the block.\n\n\nThis is an implementation of the BitCoin block, for more information see [here](https://en.bitcoin.it/wiki/Protocol_documentation#Block_Headers).","ref":"BlockChain.Block.html#module-data","title":"Data - BlockChain.Block","type":"module"},{"doc":"Add a transaction to the block.\nReturns a new block with the transaction added to the data.","ref":"BlockChain.Block.html#add_transaction/2","title":"BlockChain.Block.add_transaction/2","type":"function"},{"doc":"Creates a new block.","ref":"BlockChain.Block.html#new/4","title":"BlockChain.Block.new/4","type":"function"},{"doc":"- `version`: The version of the block.\n- `prev_block`: The hash of the previous block.\n- `merkle_root`: The root of the merkle tree of transactions.\n- `data`: The data that is stored in the block.","ref":"BlockChain.Block.html#new/4-parameters","title":"Parameters - BlockChain.Block.new/4","type":"function"},{"doc":"Documentation for `Header`.\n\nA Header is the metadata of a block. It contains the following \ninformations about the block:\n- version: The version of the block.\n- prev_block: The hash of the previous block.\n- merkle_root: The root of the merkle tree of transactions.\n- timestamp: The time the block was created.\n- ntnx_count: The number of transactions in the block.","ref":"BlockChain.Block.Header.html","title":"BlockChain.Block.Header","type":"module"},{"doc":"Documentation for `BlockChain.MerkleTreeStore`.","ref":"BlockChain.MerkleTreeStore.html","title":"BlockChain.MerkleTreeStore","type":"module"},{"doc":"Adds a new merkle tree to the store.","ref":"BlockChain.MerkleTreeStore.html#add/1","title":"BlockChain.MerkleTreeStore.add/1","type":"function"},{"doc":"Returns a specification to start this module under a supervisor.\n\nSee `Supervisor`.","ref":"BlockChain.MerkleTreeStore.html#child_spec/1","title":"BlockChain.MerkleTreeStore.child_spec/1","type":"function"},{"doc":"Gets a merkle tree from the store.","ref":"BlockChain.MerkleTreeStore.html#get_merkle_tree/1","title":"BlockChain.MerkleTreeStore.get_merkle_tree/1","type":"function"},{"doc":"- `root`: The root of the merkle tree.","ref":"BlockChain.MerkleTreeStore.html#get_merkle_tree/1-parameters","title":"Parameters - BlockChain.MerkleTreeStore.get_merkle_tree/1","type":"function"},{"doc":"Starts the BlockChain Agent.","ref":"BlockChain.MerkleTreeStore.html#start_link/1","title":"BlockChain.MerkleTreeStore.start_link/1","type":"function"},{"doc":"","ref":"BlockChain.Supervisor.html","title":"BlockChain.Supervisor","type":"module"},{"doc":"Returns a specification to start this module under a supervisor.\n\nSee `Supervisor`.","ref":"BlockChain.Supervisor.html#child_spec/1","title":"BlockChain.Supervisor.child_spec/1","type":"function"},{"doc":"","ref":"BlockChain.Supervisor.html#start_link/1","title":"BlockChain.Supervisor.start_link/1","type":"function"},{"doc":"Documentation for `Transaction`.\n  \nA Transaction is a transfer of value between two wallets. This\nmodule is responsible for creating and hashing transactions,\nto add a transaction to the blockchain use `BlockChain.Transactions`","ref":"BlockChain.Transaction.html","title":"BlockChain.Transaction","type":"module"},{"doc":"Get the hash of a transaction.","ref":"BlockChain.Transaction.html#hash/1","title":"BlockChain.Transaction.hash/1","type":"function"},{"doc":"- `transaction`: The transaction to hash.","ref":"BlockChain.Transaction.html#hash/1-parameters","title":"Parameters - BlockChain.Transaction.hash/1","type":"function"},{"doc":"Creates a new transaction and returns the updated wallet, adding\nthe trasaction to the block chain.","ref":"BlockChain.Transaction.html#new/3","title":"BlockChain.Transaction.new/3","type":"function"},{"doc":"- `from`: The public key of the sender.\n- `to`: The public key of the receiver.\n- `amount`: The amount to transfer.","ref":"BlockChain.Transaction.html#new/3-parameters","title":"Parameters - BlockChain.Transaction.new/3","type":"function"},{"doc":"Documentation for `Transactions`.\n\nThis module is responsible for saving all transactions that are not yet\nadded to the blockchain as blocks.","ref":"BlockChain.Transactions.html","title":"BlockChain.Transactions","type":"module"},{"doc":"Add a new transaction in the blockchain and updates the wallet.","ref":"BlockChain.Transactions.html#add_transaction/2","title":"BlockChain.Transactions.add_transaction/2","type":"function"},{"doc":"- `wallet`: The wallet to save.\n- `transaction`: The transaction to save.\n\nReturns `:ok` if the transaction was saved successfully.","ref":"BlockChain.Transactions.html#add_transaction/2-parameters","title":"Parameters - BlockChain.Transactions.add_transaction/2","type":"function"},{"doc":"Returns a specification to start this module under a supervisor.\n\nSee `Supervisor`.","ref":"BlockChain.Transactions.html#child_spec/1","title":"BlockChain.Transactions.child_spec/1","type":"function"},{"doc":"Clear all transactions from the agent.","ref":"BlockChain.Transactions.html#clear_transactions/0","title":"BlockChain.Transactions.clear_transactions/0","type":"function"},{"doc":"Get the trascation count.\n\nReturns the number of transactions as an integer.","ref":"BlockChain.Transactions.html#get_transaction_count/0","title":"BlockChain.Transactions.get_transaction_count/0","type":"function"},{"doc":"Get all transactions.\n\nReturns a list of all transactions not yet added to the blockchain.","ref":"BlockChain.Transactions.html#get_transactions/0","title":"BlockChain.Transactions.get_transactions/0","type":"function"},{"doc":"Starts the Transactions Agent.","ref":"BlockChain.Transactions.html#start_link/1","title":"BlockChain.Transactions.start_link/1","type":"function"},{"doc":"Documentation for `Wallet`.\n\nA Wallet is a digital wallet that contains a list \nof transactions and a public and private key.","ref":"BlockChain.Wallet.html","title":"BlockChain.Wallet","type":"module"},{"doc":"Add a transaction to the wallet, without registering it in the blockchain.\nDo not call this method directly, use `BlockChain.Transaction.new/3` instead.","ref":"BlockChain.Wallet.html#add_transaction/2","title":"BlockChain.Wallet.add_transaction/2","type":"function"},{"doc":"- `wallet`: The wallet to add the transaction to.\n- `transaction`: The transaction to add.","ref":"BlockChain.Wallet.html#add_transaction/2-parameters","title":"Parameters - BlockChain.Wallet.add_transaction/2","type":"function"},{"doc":"Get the balance of the wallet.","ref":"BlockChain.Wallet.html#balance/1","title":"BlockChain.Wallet.balance/1","type":"function"},{"doc":"- `wallet`: The wallet to get the balance of.","ref":"BlockChain.Wallet.html#balance/1-parameters","title":"Parameters - BlockChain.Wallet.balance/1","type":"function"},{"doc":"Creates a new wallet.","ref":"BlockChain.Wallet.html#new/0","title":"BlockChain.Wallet.new/0","type":"function"}],"producer":{"name":"ex_doc","version":[48,46,51,52,46,49]}}
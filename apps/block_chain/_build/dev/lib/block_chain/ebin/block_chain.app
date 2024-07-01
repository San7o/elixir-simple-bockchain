{application,block_chain,
             [{optional_applications,[]},
              {applications,[kernel,stdlib,elixir,logger,merkle_tree,ex_doc]},
              {description,"block_chain"},
              {modules,['Elixir.BlockChain','Elixir.BlockChain.Application',
                        'Elixir.BlockChain.Block',
                        'Elixir.BlockChain.Block.Header',
                        'Elixir.BlockChain.MerkleTreeStore',
                        'Elixir.BlockChain.Supervisor',
                        'Elixir.BlockChain.Transaction',
                        'Elixir.BlockChain.Transactions',
                        'Elixir.BlockChain.Wallet',
                        'Elixir.String.Chars.BlockChain.Block.Header']},
              {registered,[]},
              {vsn,"0.1.0"},
              {mod,{'Elixir.BlockChain.Application',[]}}]}.
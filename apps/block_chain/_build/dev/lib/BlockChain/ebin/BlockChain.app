{application,'BlockChain',
             [{optional_applications,[]},
              {applications,[kernel,stdlib,elixir,logger,merkle_tree]},
              {description,"BlockChain"},
              {modules,['Elixir.BlockChain','Elixir.BlockChain.Block',
                        'Elixir.BlockChain.Block.Data',
                        'Elixir.BlockChain.Block.Header',
                        'Elixir.BlockChain.Supervisor',
                        'Elixir.BlockChain.Transaction',
                        'Elixir.BlockChain.Transactions',
                        'Elixir.BlockChain.Wallet',
                        'Elixir.String.Chars.BlockChain.Block.Data',
                        'Elixir.String.Chars.BlockChain.Block.Header']},
              {registered,[]},
              {vsn,"0.1.0"}]}.
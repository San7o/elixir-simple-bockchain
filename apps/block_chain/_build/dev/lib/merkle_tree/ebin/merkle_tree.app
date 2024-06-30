{application,merkle_tree,
             [{optional_applications,[]},
              {applications,[kernel,stdlib,elixir,logger]},
              {description,"A hash tree or Merkle tree is a tree in which every non-leaf node is labelled\nwith the hash of the labels or values (in case of leaves) of its child nodes.\nHash trees are useful because they allow efficient and secure verification of\nthe contents of large data structures.\n"},
              {modules,['Elixir.MerkleTree','Elixir.MerkleTree.ArgumentError',
                        'Elixir.MerkleTree.Crypto','Elixir.MerkleTree.Node',
                        'Elixir.MerkleTree.Proof']},
              {registered,[]},
              {vsn,"2.0.0"}]}.

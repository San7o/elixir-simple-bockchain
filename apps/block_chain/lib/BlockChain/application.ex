defmodule BlockChain.Application do
  use Application

  @moduledoc """
  The application callback module.
  Starts the Transactions and BlockChain processes as
  supervised processes.
  """

  @impl true
  def start(_type, _args) do
    children = [
      BlockChain.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_all)
  end
end

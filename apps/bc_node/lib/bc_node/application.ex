defmodule BcNode.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BcNode.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_all)
  end
end

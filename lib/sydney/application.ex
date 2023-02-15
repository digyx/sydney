defmodule Sydney.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Sydney.Server, options: [port: 8080]}
    ]

    opts = [
      strategy: :one_for_one,
      name: Sydney.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end

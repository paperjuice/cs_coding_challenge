defmodule CraftingSoftware.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: CraftingSoftware.PubSub},
      CraftingSoftwareWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: CraftingSoftware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    CraftingSoftwareWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

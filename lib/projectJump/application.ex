defmodule ProjectJump.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ProjectJumpWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:projectJump, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ProjectJump.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ProjectJump.Finch},
      # Start a worker by calling: ProjectJump.Worker.start_link(arg)
      # {ProjectJump.Worker, arg},
      # Start to serve requests, typically the last entry
      ProjectJumpWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ProjectJump.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProjectJumpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

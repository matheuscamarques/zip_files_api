defmodule ZipFilesApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # credentials =
    #   "GOOGLE_APPLICATION_CREDENTIALS_JSON"
    #   |> System.fetch_env!()
    #   |> Jason.decode!()

    # source = {:service_account, credentials}

    # children = [
    #   {Goth, name: MyApp.Goth, source: source}
    # ]

    children = [
      # Start the Telemetry supervisor
      ZipFilesApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ZipFilesApi.PubSub},
      # Start the Endpoint (http/https)
      ZipFilesApiWeb.Endpoint
      # Start a worker by calling: ZipFilesApi.Worker.start_link(arg)
      # {ZipFilesApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ZipFilesApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ZipFilesApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

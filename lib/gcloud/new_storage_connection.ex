defmodule Gcloud.NewStorageConnection do
  require Logger

  def method(%Goth.Token{token: token}) do
    conn = GoogleApi.Storage.V1.Connection.new(token)

    {:ok, conn}
  end
end

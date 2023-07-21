defmodule Gcloud.CreateCloudToken do
  require Logger

  def method() do
    result = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")

    Logger.info(
      "Gcloud.CreateCloudToken/0 #{
        inspect(%{
          result: result
        })
      }"
    )

    result
  end
end

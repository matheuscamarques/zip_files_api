defmodule Gcloud.GetStorageBucket do
  @project_id "zip-files-api"
  @bucket_name "zip_files_api"
  require Logger
  def method(conn) do
    {
      :ok,
      %{items: items}
    } = result = GoogleApi.Storage.V1.Api.Buckets.storage_buckets_list(conn, @project_id)
    Logger.info(
      "Gcloud.GetStorageBucket/0 #{
        inspect(%{
          result: result
        })
      }"
    )
    Enum.find(items, fn item ->
      item.id == @bucket_name
    end)
    |> case do
      nil ->
        {:error, "Bucket not found"}

      bucket ->
        {:ok, bucket}
    end
  end
end

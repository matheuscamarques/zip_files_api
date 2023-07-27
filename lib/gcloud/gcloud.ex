defmodule Gcloud do
  alias Gcloud.{
    CreateCloudToken,
    GetStorageBucket,
    NewStorageConnection,
    UploadFile
  }

  def upload_file(file_path) do
    {:ok, token} = CreateCloudToken.method()
    {:ok, conn} = NewStorageConnection.method(token)
    {:ok, bucket} = GetStorageBucket.method(conn)

    {:ok,
     %{
       selfLink: self_link
     }} = UploadFile.method(conn, bucket, file_path)

    {:ok, self_link}
  end

  def upload_file(file_path, rename_to) do
    {:ok, token} = CreateCloudToken.method()
    {:ok, conn} = NewStorageConnection.method(token)
    {:ok, bucket} = GetStorageBucket.method(conn)

    UploadFile.method(conn, bucket, file_path, rename_to)
  end

  def download_file(file_src, target_file_path) do
    {:ok, token} = CreateCloudToken.method()
    {:ok, conn} = NewStorageConnection.method(token)
    {:ok, bucket} = GetStorageBucket.method(conn)
    file_src_prepared = URI.encode(file_src, &URI.char_unreserved?/1)

    {:ok, %{mediaLink: media_link}} =
      GoogleApi.Storage.V1.Api.Objects.storage_objects_get(conn, bucket.id, file_src_prepared)

    # Make a request to download with media link
    binary_data = http_download_file(token.token, media_link)
    # expand path
    target_file_path = Path.expand(target_file_path)
    # Write the downloaded binary data to the target file
    case File.write(target_file_path, binary_data) do
      :ok ->
        {:ok, target_file_path}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp http_download_file(token, media_link) do
    headers = [{"Authorization", "Bearer #{token}"}]
    {:ok, response} = Tesla.get(media_link, headers: headers, streaming: true)
    response.body
  end
end

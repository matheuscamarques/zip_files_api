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

    {:ok,
     %{
       selfLink: self_link
     }} = UploadFile.method(conn, bucket, file_path, rename_to)

    {:ok, self_link}
  end

  def resolve_file(file_src) do
    {:ok, token} = CreateCloudToken.method()
    {:ok, conn} = NewStorageConnection.method(token)
    {:ok, bucket} = GetStorageBucket.method(conn)
    file_src_prepared = URI.encode(file_src, &URI.char_unreserved?/1)
    {:ok, %{mediaLink: media_link}} =GoogleApi.Storage.V1.Api.Objects.storage_objects_get(conn, bucket.id, file_src_prepared)
    # make a request to download with media link
    download_file(token.token,media_link)
  end

  defp download_file(token, media_link) do
    headers = [{"Authorization", "Bearer #{token}"}]
    Tesla.get(media_link, headers: headers, streaming: true)
  end

end

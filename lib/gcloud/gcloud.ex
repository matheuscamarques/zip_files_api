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
end

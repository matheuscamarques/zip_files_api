defmodule Gcloud.Mockup do
  alias Gcloud.{
    CreateCloudToken,
    GetStorageBucket,
    NewStorageConnection,
    UploadFile
  }

  @file_path "test/upload_test_file.txt"
  def method() do
    {:ok, token} = CreateCloudToken.method()
    {:ok, conn} = NewStorageConnection.method(token)
    {:ok, bucket} = GetStorageBucket.method(conn)

    file_path = Application.app_dir(:zip_files_api, "priv") |> Path.join(@file_path)
    UploadFile.method(conn, bucket, file_path)
  end
end

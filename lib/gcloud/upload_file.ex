defmodule Gcloud.UploadFile do
  def method(conn = %{}, %GoogleApi.Storage.V1.Model.Bucket{id: bucket_id}, file_path) do
    GoogleApi.Storage.V1.Api.Objects.storage_objects_insert_simple(
      conn,
      bucket_id,
      "multipart",
      %{name: Path.basename(file_path)},
      file_path
    )
  end

  def method(conn = %{}, %GoogleApi.Storage.V1.Model.Bucket{id: bucket_id}, file_path, rename_to) do
    GoogleApi.Storage.V1.Api.Objects.storage_objects_insert_simple(
      conn,
      bucket_id,
      "multipart",
      %{name: rename_to},
      file_path
    )
  end
end

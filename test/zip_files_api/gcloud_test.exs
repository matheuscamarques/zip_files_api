defmodule ZipFilesApi.GcloudTest do
  use ZipFilesApiWeb.ConnCase, async: false

  test "Uploud File Test" do
    file_path =
      Application.app_dir(:zip_files_api, "priv") |> Path.join("test/upload_test_file.txt")

    assert {:ok, _} = Gcloud.upload_file(file_path)
  end
end

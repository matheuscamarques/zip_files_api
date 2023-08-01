defmodule ZipFilesApi.DomainTest do
  use ZipFilesApiWeb.ConnCase, async: false

  test "Receive Payload and process PDF and merge true" do
    file_path_1 = Application.app_dir(:zip_files_api, "priv") |> Path.join("test/test_image.png")
    {:ok, _file_1} = Gcloud.upload_file(file_path_1, "file1.png")

    file_path_2 =
      Application.app_dir(:zip_files_api, "priv") |> Path.join("test/test_image_2.jpg")

    {:ok, _file_2} = Gcloud.upload_file(file_path_2, "file2.png")

    payload = %{
      files: [
        %{
          document_key: "RG",
          src: "file1.png",
          person_name: "Matheus Marques",
          timestamp: DateTime.utc_now() |> DateTime.to_unix() |> Integer.to_string()
        },
        %{
          document_key: "CPF",
          src: "file2.png",
          person_name: "Matheus Marques",
          timestamp: DateTime.utc_now() |> DateTime.to_unix() |> Integer.to_string()
        }
      ],
      format: "PDF",
      merge: true,
      filename_pattern: "PERSON_NAME-TIMESTAMP-DOCUMENT_KEY.EXTENSION"
    }

    assert {:ok, %GoogleApi.Storage.V1.Model.Object{}} =
             ZipFilesApi.make_zip_file(payload) |> IO.inspect()
  end

  test "Receive Payload and process PDF and merge true and multiple persons" do
    file_path_1 = Application.app_dir(:zip_files_api, "priv") |> Path.join("test/test_image.png")
    {:ok, _file_1} = Gcloud.upload_file(file_path_1, "file1.png")

    file_path_2 =
      Application.app_dir(:zip_files_api, "priv") |> Path.join("test/test_image_2.jpg")

    {:ok, _file_2} = Gcloud.upload_file(file_path_2, "file2.png")

    payload = %{
      files: [
        %{
          document_key: "RG",
          src: "file1.png",
          person_name: "Matheus Marques"
        },
        %{
          document_key: "CPF",
          src: "file2.png",
          person_name: "Matheus Marques"
        },
        %{
          document_key: "CPF",
          src: "file2.png",
          person_name: "Igor Aguiar"
        },
        %{
          document_key: "RG",
          src: "file1.png",
          person_name: "Igor Aguiar"
        }
      ],
      format: "PDF",
      merge: true,
      filename_pattern: "PERSON_NAME-TIMESTAMP-DOCUMENT_KEY.EXTENSION"
    }

    assert {:ok, %GoogleApi.Storage.V1.Model.Object{}} =
             ZipFilesApi.make_zip_file(payload) |> IO.inspect()
  end

  test "Receive Payload and process PDF and merge false" do
    file_path_1 = Application.app_dir(:zip_files_api, "priv") |> Path.join("test/test_image.png")
    {:ok, _file_1} = Gcloud.upload_file(file_path_1, "file1.png")

    file_path_2 =
      Application.app_dir(:zip_files_api, "priv") |> Path.join("test/test_image_2.jpg")

    {:ok, _file_2} = Gcloud.upload_file(file_path_2, "file2.png")

    payload = %{
      files: [
        %{
          document_key: "RG",
          src: "file1.png",
          person_name: "Matheus Marques",
          timestamp: DateTime.utc_now() |> DateTime.to_unix() |> Integer.to_string()
        },
        %{
          document_key: "CPF",
          src: "file2.png",
          person_name: "Matheus Marques",
          timestamp: DateTime.utc_now() |> DateTime.to_unix() |> Integer.to_string()
        }
      ],
      format: "PDF",
      merge: false,
      filename_pattern: "PERSON_NAME-TIMESTAMP-DOCUMENT_KEY.EXTENSION"
    }

    assert {:ok, %GoogleApi.Storage.V1.Model.Object{}} =
             ZipFilesApi.make_zip_file(payload) |> IO.inspect()
  end
end

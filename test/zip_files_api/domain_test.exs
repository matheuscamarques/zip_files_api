defmodule ZipFilesApi.DomainTest do
  use ZipFilesApiWeb.ConnCase, async: false
  @image_src  "https://www.googleapis.com/storage/v1/b/zip_files_api/o/test_image.png"
  test "Receive Payload and process PDF merge true" do
    payload = %{
      files: [
        %{
          document_key: "RG",
          src: @image_src,
          person_name: "Igor Aguiar",
          timestamp: DateTime.utc_now() |> DateTime.to_unix() |> Integer.to_string()
        },
        %{
          document_key: "CPF",
          src: @image_src,
          person_name: "Matheus Marques",
          timestamp: DateTime.utc_now() |> DateTime.to_unix() |> Integer.to_string()
        }
      ],
      format: "PDF",
      merge: true,
      filename_pattern: "PERSON_NAME-TIMESTAMP-DOCUMENT_KEY.EXTENSION"
    }
  end
end

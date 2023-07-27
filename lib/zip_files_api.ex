defmodule ZipFilesApi do
  @moduledoc """
  ZipFilesApi keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  @type image_src() :: String.t()

  @type file() :: %{
          document_key: String.t(),
          src: image_src(),
          person_name: String.t(),
          timestamp: String.t()
        }

  # Formatos suportados: "PDF" ou "IMAGE"
  @type format() :: String.t()

  @type payload() :: %{
          files: [file()],
          format: format(),
          merge: boolean(),
          filename_pattern: String.t()
        }

  @spec make_zip_file(payload()) :: any()
  def make_zip_file(
        _payload = %{
          format: "PDF",
          merge: true,
          files: files,
          filename_pattern: _filename_pattern
        }
      ) do
    uuid = UUID.uuid1()
    # make folder /tmp/#{uuid}
    folder_path = "./folder_test/"
    File.mkdir("#{folder_path}#{uuid}")
    # download_files
    files_with_path =
      Enum.map(files, fn file_data ->
        file_name = file_data.src |> Path.basename()
        {:ok, value} = Gcloud.download_file(file_data.src, "#{folder_path}#{uuid}/#{file_name}")

        # transform to files to pdfd5
        result = Mogrify.ImageToPdf.method(value)
        # remove old_file
        File.rm!("#{folder_path}#{uuid}/#{file_name}")
        result.path
      end)

    pattern_path = "merged_test.pdf"

    {:ok, merged_file_path} =
      PdfMerger.MergePdfs.method(files_with_path, "#{folder_path}#{uuid}/#{pattern_path}")

    {:ok, filename} = :zip.create("#{folder_path}#{uuid}/#{uuid}.zip", [String.to_charlist(merged_file_path)])
    Gcloud.upload_file("#{folder_path}#{uuid}/#{uuid}.zip","#{uuid}.zip")
    # make zip file
    #
    # upload file
    # return file src
  end

  @spec make_zip_file(payload()) :: any()
  def make_zip_file(_payload) do
  end
end

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
        payload = %{
          format: "PDF",
          merge: true,
          files: files
        }
      ) do
    uuid = UUID.uuid1()
    # make folder /tmp/#{uuid}
    File.mkdir("/tmp/#{uuid}")
    # download_files
    # transform to files to pdf
    # mount filename with pattern name
    # make zip file
    #
    # upload file
    # return file src
  end

  @spec make_zip_file(payload()) :: any()
  def make_zip_file(payload) do
  end
end

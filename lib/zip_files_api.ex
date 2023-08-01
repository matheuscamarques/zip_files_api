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
    folder_path = "./folder_test/#{uuid}"
    zip_file_name = "#{uuid}.zip"
    folder_with_file_name = "#{folder_path}/#{uuid}.zip"
    File.mkdir(folder_path)

    result =
      files
      |> group_by_person_name()
      |> Enum.map(fn {person_name, files} ->
        pattern_path = "#{to_snack_case(person_name)}_export.pdf"
        folder_with_pattern_path = "#{folder_path}/#{pattern_path}"
        charlist_path = String.to_charlist(pattern_path)

        files
        |> dowload_files(folder_path)
        |> files_to_pdf(folder_path)
        |> merge_pdf_files(folder_with_pattern_path)
        |> read_file_buffer()
        |> zip_tuple_format(charlist_path)
      end)
      |> create_zip(folder_with_file_name)
      |> upload_file(zip_file_name)

    Task.start(fn -> File.rm_rf("#{folder_path}") end)
    result
  end

  defp upload_file(file_path, file_name) do
    Gcloud.upload_file(file_path, file_name)
  end

  defp create_zip(list_files_with_zip_format, file_path) do
    {:ok, filename} = :zip.create(file_path, list_files_with_zip_format)
    filename
  end

  defp zip_tuple_format(buffer_file, charlist_file_name) do
    {charlist_file_name, buffer_file}
  end

  defp read_file_buffer(merged_file_path) do
    {:ok, buffer} =
      merged_file_path
      |> String.to_charlist()
      |> :file.read_file()

    buffer
  end

  defp merge_pdf_files(files, folder_path) do
    {:ok, merged_file_path} = PdfMerger.MergePdfs.method(files, folder_path)
    merged_file_path
  end

  defp files_to_pdf(files, folder_path) do
    Enum.map(files, fn path_dowloaded_file ->
      file_name = path_dowloaded_file |> Path.basename()
      result = Mogrify.ImageToPdf.method(path_dowloaded_file)
      File.rm!("#{folder_path}/#{file_name}")
      result.path
    end)
  end

  defp dowload_files(files, folder_path) do
    Enum.map(files, fn file_data ->
      file_name = file_data.src |> Path.basename()

      {:ok, path_dowloaded_file} =
        Gcloud.download_file(file_data.src, "#{folder_path}/#{file_name}")

      path_dowloaded_file
    end)
  end

  defp group_by_person_name(files) do
    Enum.group_by(files, & &1.person_name)
  end

  def to_snack_case(str) do
    lowercase_string = String.downcase(str)
    String.replace(lowercase_string, " ", "_")
  end
end

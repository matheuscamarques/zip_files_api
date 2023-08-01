defmodule PdfMerger.MergePdfs do
  def method(input_files, output_file) do
    if pdftk_installed?() do
      merge_pdfs(input_files, output_file)
    else
      IO.puts("Error: pdftk is not installed.")
    end
  end

  defp command_exists?(command) do
    System.cmd("which", [command]) == {"/usr/bin/#{command}\n", 0}
  end

  defp pdftk_installed? do
    command_exists?("pdftk")
  end

  defp merge_pdfs(input_files, output_file) do
    output_file = Path.expand(output_file)

    files_exist? = Enum.all?(input_files, &File.exists?/1)

    if files_exist? do
      {output, status} = System.cmd("pdftk", input_files ++ ["cat", "output", "#{output_file}"])

      case status do
        0 ->
          {:ok, output_file}

        _ ->
          {:error, "Error: PDF merging failed. #{output}"}
      end
    else
      {:error, "Error: One or more input files do not exist. "}
    end
  end
end

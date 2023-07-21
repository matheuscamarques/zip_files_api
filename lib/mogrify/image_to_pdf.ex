defmodule Mogrify.ImageToPdf do
  import Mogrify

  @doc """
     install imagemagick
     install ghostscript
     comment PDF policy in file
     /etc/ImageMagick-6/policy.xml
  """
  def method(image_file_path) do
    open(image_file_path) |> format("pdf") |> save(in_place: true)
  end
end

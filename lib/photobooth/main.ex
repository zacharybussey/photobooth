defmodule Photobooth.Main do
	
	def process(:help) do
		IO.puts """
		usage photobooth --mode
		"""

		System.halt(0)
	end

	def process(:snap) do
		Photobooth.Camera.snap_image
		System.halt(0)
	end

	def process(:set) do
		current_image = Photobooth.Camera.snap_set
		if current_image < 4 do
			:timer.sleep 10000
			process :set
		end
	end

	def process(:booth) do
		process :set
		:timer.sleep 1000 # Wait for the camera to finish saving the last photo.
		Photobooth.Image.make_folder |> 
		Photobooth.Camera.download_images |>
		Photobooth.Image.montage
		Photobooth.Camera.delete_images
	end
end
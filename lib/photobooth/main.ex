defmodule Photobooth.Main do
	use GenServer

	def start_link() do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def process(:booth) do
		GenServer.cast __MODULE__, :booth
	end

	def init([]) do
		{:ok, []}
	end

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
			Photobooth.Leds.countdown
			process :set
		end
	end

	def handle_cast(:booth, state) do
		process :set
		:timer.sleep 3500 # Wait for the camera to finish saving the last photo.
		Photobooth.Image.make_folder |>
		Photobooth.Camera.download_images |>
		Photobooth.Image.montage |>
		Photobooth.Print.print
		Photobooth.Camera.delete_images
		Photobooth.Pins.finished_processing
		{:noreply, :done, state}
	end
end

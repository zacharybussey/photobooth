defmodule Photobooth.CLI do

	def main(argv) do
		argv |>
		parse_args |>
		process
	end

	def parse_args(argv) do
		parse = OptionParser.parse(argv, 
			switches: 
			[ help: :boolean, 
			snap: :boolean,
			set: :boolean],
			aliases: [h: :help ])
		case parse do
			{[help: true ], _, _}
				-> :help
			{[snap: true ], _, _}
				-> :snap
			{[set: true ], _, _}
				-> :set
			{ _, [mode], _}
				-> { mode }
			_ -> :help
		end
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
		spawn image_loop(1)

		Photobooth.Camera.download_images
		Photobooth.Camera.delete_images
	end

	def image_loop(4) do
		:ok
	end

	def image_loop(n) do
		Photobooth.Camera.snap_image
		:timer.sleep 5000
		image_loop n+1
	end
end
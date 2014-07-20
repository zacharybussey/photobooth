defmodule Photobooth.CLI do

	def run(argv) do
		argv |>
		parse_args |>
		process
	end

	def parse_args(argv) do
		parse = OptionsParser.parse(argv, switches: [ help: :boolean, 
													 snap: :boolean], 
											aliases: [h: :help ])
		case parse do
			{[help: true ], _, _}
				-> :help
			{[snap: true ], _, _}
				-> :snap
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

end
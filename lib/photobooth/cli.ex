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
		current_image = Photobooth.Camera.snap_set
		if current_image < 4 do
			:timer.sleep 10000
			process :set
		end
	end

	def start_agents(args) do
		Photobooth.Supervisor.start_link {1, 4}
	end
end
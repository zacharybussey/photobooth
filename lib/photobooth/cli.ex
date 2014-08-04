defmodule Photobooth.CLI do

	def main(argv) do
		argv |>
		parse_args |>
		Main.process
	end

	def parse_args(argv) do
		parse = OptionParser.parse(argv, 
			switches: 
			[ help: :boolean, 
			snap: :boolean,
			set: :boolean,
			booth: :boolean],
			aliases: [h: :help ])
		case parse do
			{[help: true ], _, _}
				-> :help
			{[snap: true ], _, _}
				-> :snap
			{[set: true ], _, _}
				-> :set
			{[booth: true ], _, _}
				-> :booth
			{ _, [mode], _}
				-> { mode }
			_ -> :help
		end
	end

	def start_agents(args) do
		Photobooth.Supervisor.start_link {1, 4}
	end
end
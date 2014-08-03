defmodule Photobooth do
	use Application

	def start(_type, _args) do
		Photobooth.CLI.start_agents []
	end
end
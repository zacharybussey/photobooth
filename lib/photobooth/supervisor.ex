defmodule Photobooth.Supervisor do
	use Supervisor

	def start_link(inital_values) do
		result = {:ok, sup } = Supervisor.start_link(__MODULE__, [inital_values])
		start_workers(sup, inital_values)
		result
	end

	def init(_) do
		supervise [], strategy: :one_for_one
	end

	def start_workers(sup, inital_values) do
		{:ok, stash } = Supervisor.start_child(sup, worker(Photobooth.Stash, [inital_values]))
		{:ok, camera } = Supervisor.start_child(sup, supervisor(Photobooth.Camera, [stash]))
		{:ok, pins } = Supervisor.start_child(sup, supervisor(Photobooth.Pins, []))
		{:ok, main } = Supervisor.start_child(sup, supervisor(Photobooth.Main, []))
		{:ok, leds } = Supervisor.start_child(sup, supervisor(Photobooth.Leds, []))
		#IO.inspect "Camera started on #{camera}"
	end
end
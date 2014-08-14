defmodule Photobooth.Pins do
	use GenServer

	def start_link() do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def init([]) do
		Gpio.start_link 17, :input #Access exception
		{:ok, shutter_pid} = Gpio.start_link 17, :input
		IO.puts "Started pin monitor on pid #{shutter_pid}"
		{:ok, {shutter_pid }}
	end

	def handle_call{{:gpio_interrupt, 17, :rising}, _from, { shutter_pid } } do
		IO.puts "handle_call from button press."
		Photobooth.Main.process :booth
		{:ok, { shutter_pid}}
	end

	def terminate(_reason, {shutter_pid}) do
		Gpio.release shutter_pid
	end
end
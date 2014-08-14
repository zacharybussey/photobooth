defmodule Photobooth.Pins do
	use GenServer

	def start_link() do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def init() do
		Gpio.start_link 17, :input #Access exception
		{:ok, shutter_pid} = Gpio.start_link 17, :input
		{:ok, {shutter_pid }}
	end

	def handle_call{{:gpio_interrupt, 17, :rising}, _from, { shutter_pid } } do
		Photobooth.Main.process :booth
		{:ok, { shutter_pid}}
	end

	def terminate(reason, {shutter_pid}) do
		Gpio.release shutter_pid
	end
end
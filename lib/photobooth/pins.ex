defmodule Photobooth.Pins do
	use GenServer

	defmodule State do
		defstruct shutter_button: nil, busy: false
	end

	def start_link() do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def countdown() do
		GenServer.call __MODULE__, :countdown
	end

	def finished_processing() do
		GenServer.cast __MODULE__, :finished
	end

	def init([]) do
		Gpio.start_link 17, :input #Access exception
		{:ok, shutter_pid} = Gpio.start_link 17, :input

		state = %State{ shutter_button: shutter_pid }
		Gpio.set_int shutter_pid, :rising
		IO.puts "Started pins"
		{:ok, state }
	end

	def handle_info({:gpio_interrupt, 17, :rising}, state ) do
		IO.puts "handle rising callback from button press."
		if state.busy == false do
			Photobooth.Main.process :booth
			state = %{state | busy: true }
		end

		{:noreply, state}
	end

	def handle_info({:gpio_interrupt, 17, :falling}, state ) do
		IO.puts "handle falling callback from button press."
		#Photobooth.Main.process :booth
		{:noreply, state }
	end

	def handle_cast(:finished, state ) do
		state = %{state | busy: false }
		{:noreply, state }
	end

	def terminate(_reason, state) do
		Gpio.release state.shutter_button
	end
end

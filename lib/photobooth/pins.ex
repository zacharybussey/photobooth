defmodule Photobooth.Pins do
	use GenServer

	defmodule State do
		defstruct led1: nil, led2: nil, led3: nil, led4: nil, shutter_button: nil, busy: false
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
		{:ok, led1_pid} = Gpio.start_link 21, :output
		{:ok, led2_pid} = Gpio.start_link 22, :output
		{:ok, led3_pid} = Gpio.start_link 23, :output
		{:ok, led4_pid} = Gpio.start_link 24, :output
		state = %State{led1: led1_pid, led2: led2_pid,
			led3: led3_pid, led4: led4_pid, shutter_button: shutter_pid }
		Gpio.set_int shutter_pid, :rising
		IO.puts "Started pins"
		{:ok, {shutter_pid, state }}
	end

	def handle_info({:gpio_interrupt, 17, :rising}, state ) when state.busy = false do
		IO.puts "handle rising callback from button press."
		Photobooth.Main.process :booth
		state = %{state | busy: true }
		{:noreply, state}
	end

	def handle_info({:gpio_interrupt, pin, state}, state ) when state.busy = true do
		{:noreply, state }
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

	def handle_call(:countdown, state) do
		Gpio.write state.led1 1
		{:reply, state}
	end

	defp blink() do
		Gpio.write state.led1 1
		Gpio.write state.led2 1
		Gpio.write state.led3 1
		Gpio.write state.led4 1
		:timer.sleep 500
		Gpio.write state.led1 0
		Gpio.write state.led2 0
		Gpio.write state.led3 0
		Gpio.write state.led4 0
	end

	def terminate(_reason, state) do
		Gpio.release state.shutter_button
		Gpio.release state.led1
		Gpio.release state.led2
		Gpio.release state.led3
		Gpio.release state.led4
	end
end
defmodule Photobooth.Leds do
	use GenServer

	def start_link() do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def countdown() do
		GenServer.call __MODULE__, :countdown, 6000
	end

	def init([]) do
		{:ok, led1_pid} = Gpio.start_link 21, :output
		{:ok, led2_pid} = Gpio.start_link 22, :output
		{:ok, led3_pid} = Gpio.start_link 23, :output
		{:ok, led4_pid} = Gpio.start_link 24, :output
		pins = [led1_pid, led2_pid, led3_pid, led4_pid]
		all_off pins
		{:ok, pins }
	end

	def handle_call(:countdown, _from, pins) do
		blink pins
		blink pins
		countoff pins
		{:reply, :ok, pins}
	end

	defp countoff(pins) do
		all_on pins
		Enum.map pins, &(off_with_pause &1)
	end

	defp off_with_pause(pin) do
		Gpio.write pin, 1
		:timer.sleep 1000
	end

	defp blink(pins) do
		all_on pins
		:timer.sleep 500
		all_off pins
	end

	defp all_on(pins) do
		Enum.map pins, &(Gpio.write &1, 0)
	end

	defp all_off(pins) do
		Enum.map pins, &(Gpio.write &1, 1)
	end

	def terminate(_reason, pins) do
		pins |> Enum.map &(Gpio.release &1)
	end
end
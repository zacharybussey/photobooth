defmodule Photobooth.Leds do
	use GenServer

	def start_link() do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def countdown() do
		GenServer.call __MODULE__, :countdown
	end

	def init([]) do
		{:ok, led1_pid} = Gpio.start_link 21, :output
		{:ok, led2_pid} = Gpio.start_link 22, :output
		{:ok, led3_pid} = Gpio.start_link 23, :output
		{:ok, led4_pid} = Gpio.start_link 24, :output

		{:ok, [led1_pid, led2_pid, led3_pid, led4_pid] }
	end

	def handle_call(:countdown, _from, pins) do
		blink pins
		{:reply, pins}
	end

	defp blink(pins) do
		Enum.map pins, &(Gpio.write &1, 1)
		:timer.sleep 500
		Enum.map pins, &(Gpio.write &1, 0)
	end

	def terminate(_reason, pins) do
		pins |> Enum.map &(Gpio.release &1)
	end
end
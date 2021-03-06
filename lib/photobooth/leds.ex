defmodule Photobooth.Leds do
	use GenServer

	def start_link() do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def countdown() do
		GenServer.call __MODULE__, :countdown, 6000
	end

	def init([]) do

		[21..24] |> Enum.map &(init_pins &1)

		{:ok, led1_pid} = Gpio.start_link 21, :output
		{:ok, led2_pid} = Gpio.start_link 22, :output
		{:ok, led3_pid} = Gpio.start_link 23, :output
		{:ok, led4_pid} = Gpio.start_link 24, :output
		pins = [led1_pid, led2_pid, led3_pid, led4_pid]
		all_off pins
		{:ok, pins }
	end

	defp init_pins(pin) do
		:os.cmd 'gpio write %{pin} 0'
		:os.cmd 'gpio export %{pin} out'
	end

	def handle_call(:countdown, _from, pins) do
		all_on pins
		:timer.sleep 500
		countoff pins
		blink pins
		blink pins
		{:reply, :ok, pins}
	end

	defp countoff(pins) do
		Enum.map pins, &(off_with_pause &1)
	end

	defp off_with_pause(pin) do
		Gpio.write pin, 1
		:timer.sleep 1000
	end

	defp blink(pins) do
		all_on pins
		:timer.sleep 250
		all_off pins
		:timer.sleep 250
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

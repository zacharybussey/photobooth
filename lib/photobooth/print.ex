defmodule Photobooth.Print do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, [] }
  end

  def print(filename) do
    #IO.puts "printing"
		#GenServer.cast __MODULE__, {:print, filename}
  end

  def handle_cast({:print, filename}, state) do
    IO.puts "printing"
    #:os.cmd 'lp #{filename}'
    IO.puts result
    {:noreply, state }
  end

end

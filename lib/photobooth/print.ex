defmodule Photobooth.Print do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, [] }
  end

  def print(filename) do
    :os.cmd 'mutt -s "Ben and Rebecca Wedding 9/13/14" -a #{filename} -- trivett@print.epsonconnect.com < /home/pi/message.txt'
    #IO.puts "printing"
		#GenServer.cast __MODULE__, {:print, filename}
  end

  def handle_cast({:print, filename}, state) do
    IO.puts "printing"
    #:os.cmd 'lp #{filename}'
    #:os.cmd 'mutt -s "Ben and Rebecca Wedding 9/13/14" -a #{filename} -- trivett@print.epsonconnect.com < /home/pi/message.txt'
    result = :os.cmd 'mutt -s "Ben and Rebecca Wedding 9/13/14" -a #{filename} -- zacharybussey@gmail.com < /home/pi/message.txt'
    IO.puts result
    {:noreply, state }
  end

end
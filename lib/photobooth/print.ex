defmodule Photobooth.Print do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, [] }
  end

  def print(filename) do
		GenServer.call __MODULE__, {:countdown, filename}
  end

  def handle_cast({:print, filename}, _) do
    #os print command
    {:noreply, _}
  end

end

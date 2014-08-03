defmodule Photobooth.Camera do
	use GenServer

	#public api

	def start_link(stash_pid) do
		GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
	end

	def snap_set() do
		IO.puts "Starting capture of images"
		#timer = Process.send_after(__MODULE__, {:snap_set, 0, images_to_capture}, 1)
		GenServer.cast __MODULE__, {:snap_set, 0}
		#{:ok, timer}
		#{:ok}
	end

	#Genserver implementation

	def init(stash_pid) do
		current_image = Photobooth.Stash.get_value stash_pid
		{ :ok, {current_image, 4, stash_pid} }
	end

	def handle_cast({:snap_set, next_image}, {current_image, images_to_capture, stash_pid}) do
		IO.puts "Caputring image #{current_image} of #{images_to_capture}"
		snap_image |> process_response {current_image, images_to_capture, stash_pid}
		if current_image < images_to_capture do
			Process.send_after(__MODULE__, {:snap_set, next_image + 1, images_to_capture, stash_pid}, 1)
		else
			{:noreply, {0, 0, stash_pid } }
		end
		{:noreply, {current_image + 1, images_to_capture, stash_pid } }
	end

	def terminate(reason, {current_image, images_to_capture, stash_pid}) do
		IO.inspect reason
		Photobooth.Stash.save_value stash_pid, {current_image, images_to_capture}
	end

	#shell commands

	def snap_image do
		#Returns [] if successful, or '' with error message on error.	
		:os.cmd 'gphoto2 --capture-image'
	end
	
	def delete_images do
		:os.cmd 'gphoto2 --folder=\'/store_00010001/DCIM/100D3000\' --delete-all-files'
	end

	def download_images do
		:os.cmd 'gphoto2 --get-all-files'
	end

	defp process_response(response, state) do
		if is_list response do
			:ok
		else
			terminate(response, state)
		end
	end
end
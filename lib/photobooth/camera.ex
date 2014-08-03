defmodule Photobooth.Camera do
	use GenServer

	#public api

	def start_link(stash_pid) do
		GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
	end

	def snap_set() do
		IO.puts "Starting capture of images"
		#timer = Process.send_after(__MODULE__, {:snap_set, 0, images_to_capture}, 1)
		#GenServer.cast __MODULE__, {:snap_set}
		GenServer.call __MODULE__, :snap
		#{:ok, timer}
		#{:ok}
	end

	#Genserver implementation

	def init(stash_pid) do
		{current_image, images_to_capture} = Photobooth.Stash.get_value stash_pid
		IO.puts "Started camera"
		{ :ok, {current_image, images_to_capture, stash_pid} }
	end

	def handle_call(:snap, _from, {current_image, images_to_capture, stash_pid}) do
		IO.puts "Caputring image #{current_image} of #{images_to_capture}"
		
		snap_image |> process_response {current_image, images_to_capture, stash_pid}
		if current_image >= images_to_capture do
			{:reply, current_image, {1, 4, stash_pid } }
		else
			{ :reply, current_image, {current_image + 1, images_to_capture, stash_pid }}
		end
	end

	def terminate(reason, {current_image, images_to_capture, stash_pid}) do
		IO.inspect reason
		Photobooth.Stash.save_value stash_pid, {current_image, images_to_capture}
	end

	#shell commands

	def snap_image do
		#Returns [] if successful, or '' with error message on error.
		IO.puts "Snaped single image."
		:os.cmd 'gphoto2 --capture-image'
	end
	
	def delete_images do
		:os.cmd 'gphoto2 --folder=\'/store_00010001/DCIM/100D3000\' --delete-all-files'
	end

	def download_images do
		:os.cmd 'gphoto2 --get-all-files'
	end

	defp process_response(response, state) do
		if length response = 0 do
			IO.puts "Processed OK."
			:ok
		else
			IO.puts "terminate"
			terminate(response, state)
		end
	end
end
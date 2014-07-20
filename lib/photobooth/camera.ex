defmodule Photobooth.Camera do

	def snap_image do
		#System.cmd "gphoto2", ["--capture-image"]
		spawn fn -> :os.cmd 'gphoto2 --capture-image' end
	end
	
end
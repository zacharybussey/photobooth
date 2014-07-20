defmodule Photobooth.Camera do

	def snap_image do
		#System.cmd "gphoto2", ["--capture-image"]
		:os.cmd 'gphoto2 --capture-image'
	end
	
end
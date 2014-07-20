defmodule Photobooth.Camera do

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
end
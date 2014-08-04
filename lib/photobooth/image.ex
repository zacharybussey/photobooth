defmodule Photobooth.Image do
	def montage(image_path) do
		:os.cmd '''
			gm montage -geometry 640x480+5+5 -tile 1x4 
			-bordercolor black -borderWidth 5 #{image_path}/*.jpg #{image_path}/booth.jpg
			'''
	end

	def make_folder do
		image_path = Path.expand "~/Images"
		if !File.exists? image_path do
			File.mkdir! image_path
		end
		folders = [0] ++ parse_folders(image_path)
		newFolderNum = Enum.max(folders) + 1
		newFolder = "#{image_path}/#{newFolderNum}"
		File.mkdir_p! newFolder
		newFolder
	end

	def parse_folders(path) do
		File.ls!(path) |> Enum.map(&String.to_integer/1)
	end
end
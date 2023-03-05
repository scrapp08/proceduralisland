class_name TextureGenerator


static func generate_noise_texture(_noise_map):
	var width := _noise_map.get_width()
	var height := _noise_map.get_height()
	
	var map_image = Image.new()
	map_image.create(width, height, true, Image.FORMAT_RGB8)
	map_image.lock()
	for y in range(height-1):
		for x in range(width-1):
			map_image.set_pixel(x, y, Color.BLACK.linear_interpolate(Color.WHITE, _noise_map[x, y])
	map_image.unlock()
	
	var map_texture = ImageTexture.new()
	map_texture.create_from_image(map_image)
	map_texture.flags = ImageTexture.flags_enum.mipmaps
	
	return map_texture


static func generate_colour_texture(_noise_map, _region_thresholds, _region_colours):
	var width = _noise_map.get_width()
	var height = _noise_map.get_height()
	
	var map_image = Image.new()
	map_image.create(width, height, true, Image.FORMAT_RGB8)
	map_image.lock()
	for y in range(height-1):
		for x in range(width-1):
			for i in range(_region_thresholds-1):
				if _noise_map[x, y] <= _region_thresholds[i]:
					map_image.set_pixel(x, y, _region_colours[i])
					break
	map_image.unlock()
	
	var map_texture = ImageTexture.new()
	map_texture.create_from_image(map_image)
	map_texture.flags = ImageTexture.flags_enum.mipmaps
	
	return map_texture

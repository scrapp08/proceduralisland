class_name NoiseMap


static func noise_map(seed : int, height : int, width : int, scale : float, offset : Vector2):
	var noise_map = [[width],[height]]
	var simplex_noise := FastNoiseLite.new()
	simplex_noise.TYPE_SIMPLEX
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	simplex_noise.seed = seed
	simplex_noise.frequency = 8
	simplex_noise.fractal_octaves = 3
	simplex_noise.fractal_lacunarity = 0.8
	
	var max_noise = float(1.79769e308)
	var min_noise = float(-1.79769e308)
	
	for y in range(height - 1):
		for x in range(width - 1):
			var sample_x = (x + offset.x - width / 2) / scale
			var sample_y = (y + offset.y -  height / 2) / scale
			noise_map[x, y] = simplex_noise.get_noise_2d(sample_x, sample_y)
			max_noise = max(max_noise, noise_map[x, y])
			min_noise = min(min_noise, noise_map[x, y])
			
	for y in range(height - 1):
		for x in range(width - 1):
			noise_map[x, y] = inverse_lerp(min_noise, max_noise, noise_map[x, y])
	
	return noise_map

class_name MeshGenerator


static func generate_mesh(_noise_map, _height_multiplier: float, _height_curve: Curve, _lod : int) -> ArrayMesh:
	var width : int = _noise_map.get_width()
	var height : int = _noise_map.get_height()
	
	var vertices : Array[Vector3]
	vertices.resize(width*height)
	var normals : Array[Vector3]
	normals.resize(width*height)
	var uvs : Array[Vector2]
	uvs.resize(width*height)
	var indices := [(width - 1) * (height - 1) * 6]
	
	var top_left_x := (width - 1) / -2.0
	var top_left_z := (height - 1) / -2.0
	
	var simplification_factor := 1 if _lod == 0 else _lod * 2
	var vertices_per_line := (width - 1) / simplification_factor + 1
	
	var vertices_idx := 0
	for y in range(height - 1):
		for x in range(width - 1):
			vertices[vertices_idx] = Vector3(top_left_x + x, _height_curve.interpolate(_noise_map[x, y]) * _height_multiplier, top_left_z + y)
			uvs[vertices_idx] = Vector2(x / float(width), y / float(height))
			vertices_idx = ++vertices_idx
	
	var indices_idx = 0
	vertices_idx = 0
	for y in range(height - 1):
		for x in range(width - 1):
			if (x < width - 1 and y < height - 1):
				_add_triangle(vertices, indices, normals, vertices_idx, vertices_idx + vertices_per_line + 1, vertices_idx + vertices_per_line, indices_idx)
				_add_triangle(vertices, indices, normals, vertices_idx, vertices_idx + 1, vertices_idx + vertices_per_line + 1, indices_idx + 3)
				indices_idx += 6
			vertices_idx = ++vertices_idx
	
	var mesh_arrays = []
	mesh_arrays.resize(int(ArrayMesh.ARRAY_MAX))
	mesh_arrays[int(ArrayMesh.ARRAY_VERTEX)] = vertices
	mesh_arrays[int(ArrayMesh.ARRAY_TEX_UV)] = uvs
	mesh_arrays[int(ArrayMesh.ARRAY_INDEX)] = indices
	mesh_arrays[int(ArrayMesh.ARRAY_NORMAL)] = normals
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(mesh.PRIMITIVE_TRIANGLES, mesh_arrays)
	return mesh


static func _calculate_normal(a : Vector3, b : Vector3, c : Vector3):
	var v1 : Vector3 = b - a
	var v2 : Vector3 = b - c
	return v1.cross(v2).normalized()


static func _add_triangle(vertices, indices : Array, normals, a : int, b : int, c : int, index : int):
	indices[index] = a
	indices[index + 1] = b
	indices[index + 2] = c
	
	normal = _calculate_normal(vertices[a], vertices[b], vertices[c])
	normals[a] += normal
	normals[a] = normals[a].normalized()
	normals[b] += normal
	normals[b] = normals[b].normalized()
	normals[c] += normal
	normals[c] = normals[c].normalized()

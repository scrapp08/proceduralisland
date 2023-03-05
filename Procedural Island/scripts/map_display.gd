@tool

extends Node3D

enum DrawMode{NOISE_MAP, COLOUR_MAP, MESH}

@export var draw_mode : DrawMode :
	set (value):
		_draw_mode = value
		draw_map()
	get:
		return _draw_mode
@export_category("Noise Map")
@export var map_seed : int :
	set (value):
		_map_seed = value
		draw_map()
	get:
		return _map_seed
@export var map_width : int :
	set (value):
		_map_width = value
		draw_map()
	get:
		return _map_width
@export var map_height : int :
	set (value):
		_map_height = value
		draw_map()
	get:
		return _map_height
@export var map_scale : float :
	set (value):
		_map_scale = value
		draw_map()
	get:
		return _map_scale
@export var map_offset : Vector2 :
	set (value):
		_map_offset = value
		draw_map()
	get:
		return _map_offset
@export_category("Region")
@export var region_thresholds : Array[float] :
	set (value):
		_region_thresholds = value
		draw_map()
	get:
		return _region_thresholds
@export var region_colours : Array[Color] :
	set (value):
		_region_colours = value
		draw_map()
	get:
		return _region_colours
@export_category("Mesh")
@export var mesh_height_multiplier : float :
	set (value):
		_mesh_height_multiplier = value
		draw_map()
	get:
		return _mesh_height_multiplier
@export var mesh_height_curve : Curve :
	set (value):
		_mesh_height_curve = value
		draw_map()
	get:
		return _mesh_height_curve
@export_range(0, 6, 1) var level_of_detail : int :
	set (value):
		_level_of_detail = value
		draw_map()
	get:
		return _level_of_detail

var _draw_mode : DrawMode

var _map_seed : int
var _map_width : int
var _map_height : int
var _map_scale : float
var _map_offset : Vector2
var _noise_map : Array = [[],[]]

var _region_thresholds : Array[float]
var _region_colours : Array[Color]

var _mesh_height_multiplier : float
var _mesh_height_curve : Curve

var _level_of_detail : int

var is_ready := false


func _ready() -> void:
	is_ready = true
	draw_map()


func draw_map():
	if not is_ready: return
	_generate_noise_map()
	if draw_mode == DrawMode.COLOUR_MAP:
		_generate_colour_texture()
	elif draw_mode == DrawMode.MESH:
		_generate_mesh()
	else:
		_generate_noise_texture()

func _generate_noise_map():
	_noise_map = NoiseMap.noise_map(map_seed, map_width, map_height, map_scale, map_offset)


func _generate_mesh():
	var mesh : ArrayMesh = MeshGenerator.generate_mesh(_noise_map, mesh_height_multiplier, mesh_height_curve, level_of_detail)
	var mesh_instance : MeshInstance3D = get_node("MeshInstance3D")
	mesh_instance.mesh = mesh
	mesh_instance.create_trimesh_collision()
	
	var material := StandardMaterial3D.new()
	material.albedo_texture = TextureGenerator.generate_colour_texture(_noise_map, region_thresholds, region_colours)
	mesh.surface_set_material(0, material)


func _generate_noise_texture():
	var material := get_node("Plane").material as StandardMaterial3D
	material.albedo_texture = TextureGenerator.generate_noise_texture(_noise_map)


func _generate_colour_texture():
	var material := get_node("Plane").material as StandardMaterial3D
	material.albedo_texture = TextureGenerator.generate_colour_texture(_noise_map, region_thresholds, region_colours)

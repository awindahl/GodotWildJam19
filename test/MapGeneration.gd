extends Node

var level_size = 5
export var tile_size = 20
export var real_map = true
var scope = 3
var radius = int(floor(scope/2))
var biomes = []
onready var pre_load_biomes = {}


var map = []
var map_info = []
var saved_coords = []


func _ready():
	# The scope value has to be at least one-third of the level-size.
	# This will prevent a false scope value from an invalid array call on our map
	if level_size / scope < scope :
		level_size = scope * 3
	if real_map:
		biomes = ["NoIsland", "Island1"]
		for biome in biomes:
			pre_load_biomes[biome] = load("res://islands/tiles/%s.tscn" % biome)
	else:
		biomes = ["sea", "island1"]
		for biome in biomes:
			pre_load_biomes[biome] = load("res://tiles/%s.tscn" % biome)
	
	create_map()
	saved_coords = coordinates().duplicate()
	spawn_tiles()


func create_map():
	# Refresh seed
	randomize()

	# Create a map that holds the level tiles
	for x in range(level_size):
		var row = []
		var row_info = []
		for z in range(level_size):
			row.append(biomes[int(rand_range( 0, biomes.size() ))])
			row_info.append([false, randf(), randf(), Vector2(x, z)])
		map.append(row)
		map_info.append(row_info)
	# Make initial tile empty
	map[0][0] = biomes[0]

func coordinates():
	var x = floor(get_parent().get_node("player_ship_1").get_translation().x)
	var z = floor(get_parent().get_node("player_ship_1").get_translation().z)
	x = int(x / tile_size) % (level_size)
	z = int(z / tile_size) % (level_size)
	return [x, z]



func pattern():
	var pattern = []

	# Lists current visible tiles
	var x = -radius
	var z = -radius

	# Create a two-dimensional grid. Size is based on our predefined scope
	for a in scope:
		for b in scope:

			var id = [coordinates()[0] + x, coordinates()[1] + z]
			pattern.append(id)

			if x < (radius * radius):
				x += 1
		if z < (radius * radius):
			z += 1
		x = -radius
		
	return pattern

func spawn_tiles():
	var x = int(floor(get_parent().get_node("player_ship_1").get_translation().x))
	var z = int(floor(get_parent().get_node("player_ship_1").get_translation().z))

	var pattern = pattern()
	var tile = 0
	var offeset_x = -radius
	var offeset_z = -radius

	for a in scope:
		for b in scope:
			for new in pattern:
				if pattern[tile] == new:
					var pos_x = pattern[tile][0]
					var pos_z = pattern[tile][1]

					# If the value is negative or higher than the level size we have to normalize it
					if pos_x < 0:
						pos_x = level_size + pos_x
					elif pos_x >= level_size:
						pos_x = level_size - pos_x

					if pos_z < 0:
						pos_z = level_size + pos_z
					elif pos_z >= level_size:
						pos_z = level_size - pos_z

					# Make sure the received values are always positive
					if pos_x < 0:
						pos_x *= -1
					if pos_z < 0:
						pos_z *= -1

					var type = map[pos_x][pos_z]
					var tile_info = map_info[pos_x][pos_z]
					
					#var tilescene = load("res://tiles/%s.tscn" % str(type))
					var tilescene = pre_load_biomes[str(type)]
					var new_tile = tilescene.instance()

					# The following 6 lines are optional and are meant to beautify the spawn position if the value is negative
					if x % tile_size != 0:
						var mod = x % tile_size
						x = x - mod
					if z % tile_size != 0:
						var mod = z % tile_size
						z = z - mod

					var tile_x = int( x  + ( offeset_x * tile_size ))
					var tile_z = int( z  + ( offeset_z * tile_size ))

					var name = str(tile_x) + str(tile_z)

					new_tile.set_translation(Vector3(tile_x, 0, tile_z))
					new_tile.set_name("tile" + str(name))
					if type == 'Island1':
						new_tile.tile_size = tile_size
						new_tile.add_info(tile_info)

					self.get_parent().call_deferred("add_child", new_tile)
			tile += 1
			if offeset_x < (radius * radius):
				offeset_x += 1
		if offeset_z < (radius * radius):
			offeset_z += 1
		# Reset the iterator when "a" iterates
		offeset_x = -radius

	# Clear the old coordinates and save the current ones
	saved_coords.clear()
	saved_coords = coordinates().duplicate()


func _physics_process(delta):
	# Create new tiles if
	# position has changed
	if coordinates() != saved_coords:
		for tile in get_parent().get_children():
			if "tile" in tile.name:
				tile.queue_free()
		spawn_tiles()


func update_tile_visibility(pos):
	#print(origin, map_info[origin.substr(4,5)], map_info[origin.substr(6,7)])
	map_info[pos.x][pos.y][0] = true

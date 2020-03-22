extends Spatial

const IconSea = preload("res://map/2d/icons/Sea.tscn")
const IconI1 = preload("res://map/2d/icons/I1.tscn")
const IconI2 = preload("res://map/2d/icons/I2.tscn")
const IconI3 = preload("res://map/2d/icons/I3.tscn")
const IconI4 = preload("res://map/2d/icons/I4.tscn")
var icon_list = [IconSea, IconI1, IconI2, IconI3, IconI4]

# Change here
export var real_map = true
var level_size = 9
var tile_size = 25
var scope = 5
var number_of_islands = 50  # There can be one less value than this if
# there is an island spawn on origin player position. 0 means random
var radius
var biomes = []
onready var pre_load_biomes = {}

var map = []
var saved_coords = []
var biome_list = []
var island_holder = {}

var player_map_size = Vector2()
var tile_ratio = 1

func _ready():
	#var player_start_pos = Vector2(round(tile_size+level_size/2), round(tile_size*level_size/2))
	#get_parent().move_player_to(player_start_pos)
	radius = int(floor(scope/2))
	$PlayerMap.visible = false
	#var screen_size = get_viewport().get_rect().size
	player_map_size = Vector2(get_viewport().size.x - $PlayerMap.position.x*2 - 64, 
		get_viewport().size.y - $PlayerMap.position.y*2)
	
	# The scope value has to be at least one-third of the level-size.
	# This will prevent a false scope value from an invalid array call on our map
	if level_size / scope < scope :
		level_size = scope * 3
	tile_ratio = player_map_size / (level_size-1)
	print(tile_ratio)
	#var player_start = Vector3(
	#	floor(tile_size/2.0)*tile_ratio.x, 
	#	get_parent().get_node("player_ship_1").get_translation().x,
	#	floor(tile_size/2.0)*tile_ratio.y)
	#get_parent().get_node("player_ship_1").set_translation(player_start)
	#print('lvl', level_size)
	
	if real_map:
		#biomes = ["NoIsland", "Island1"]
		#biomes = ["Empty", "Island1", "Island2"]
		biomes = ["Empty", "Island1", "Island2", "Island3", 'SandIsland']
		for biome in biomes:
			pre_load_biomes[biome] = load("res://islands/tiles/%s.tscn" % biome)
	else:
		biomes = ["sea", "island1"]
		for biome in biomes:
			pre_load_biomes[biome] = load("res://tiles/%s.tscn" % biome)
	
	create_map()
	create_player_map()
	
	# Move player to middle of map
	saved_coords = coordinates().duplicate()
	$PlayerMap/SeaTiles.get_children()[saved_coords[0]*tile_size + saved_coords[1]].visible = false
	spawn_tiles()


func create_map():
	# Refresh seed
	randomize()
	
	if number_of_islands != 0:
		# Can only generate at maximum one island per grid tile minus origin one
		for _idx in range(min(number_of_islands, level_size*level_size)):
			biome_list.append(randi()%4+1) # Create random vector of islands
		# Fill remaining tiles, if any, with empty
		for _idx in range(level_size*level_size-number_of_islands): 
			biome_list += [0]
		biome_list.shuffle()
		#biome_list[0] = 0
	#print('Island spawn: ', biome_list)
	#for row in range(level_size):
	#	print(biome_list.slice(level_size*row, level_size*row+level_size-1))
	# Create a map that holds the level tiles
	var biome_idx = 0
	for x in range(level_size):
		var row = []
		var row_info = []
		for z in range(level_size):
			#row.append(biomes[int(rand_range( 0, biomes.size() ))])
			if number_of_islands == 0:
				row.append({'biome': biomes[int(rand_range( 0, biomes.size() ))], \
					"visited": false, "x_disp": randf()*tile_size, "rotation": randf()*360, \
					"tile_pos": Vector2(x, z), "tile_size": tile_size})
			else: #randf()*.5*tile_size,  randf()*360
				row.append({'biome': biomes[biome_list[biome_idx]], \
					"visited": false, "x_disp": 0, \
					"rotation": 0, \
					"tile_pos": Vector2(x, z), "tile_size": tile_size})
				if (x!=0) or (z!=0):
					# Origin tile will be replaced by empty tile, so only go to 
					# next tile if current is not origin
					biome_idx += 1
		map.append(row)
		#map_info.append(row_info)
	# Make initial tile empty
	var mid_map = round(level_size/2)
	emit_signal("spawn_player", mid_map)
	map[0][0]['biome'] = biomes[0]
	
	#get_tree().call_group("player_map", "make", map, biome_list, level_size, tile_size, number_of_islands)

func coordinates():
	var x = floor(get_parent().get_node("Player").get_translation().x)
	var z = floor(get_parent().get_node("Player").get_translation().z)
	x = int(x / tile_size) % (level_size)
	z = int(z / tile_size) % (level_size)
	return [x, z]

func non_round_coordinates():
	var x = get_parent().get_node("Player").get_translation().x# - tile_size/2
	var z = get_parent().get_node("Player").get_translation().z# + tile_size/2
	var rot = get_parent().get_node("Player/Ship").get_transform().basis.get_euler()
	x = fposmod(x / (tile_size), level_size)
	z = fposmod(z / (tile_size), level_size)
	return [x, z, rot]

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
	var x = int(floor(get_parent().get_node("Player").get_translation().x))
	var z = int(floor(get_parent().get_node("Player").get_translation().z))

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
					#print('X ', pos_x, '  Z ', pos_z)
					#print(map[pos_x][pos_z])
					var type = map[pos_x][pos_z]['biome']
					#var tile_info = map_info[pos_x][pos_z]
					
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
					if real_map: # and (type != 'Empty'):
						#new_tile.tile_size = tile_size
						new_tile.add_info(map[pos_x][pos_z])

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
		# Make current tile visible in map
		#var player_pos = coordinates()
		#print('coord ', player_pos)
		#var player_pos_vec = Vector2(player_pos[0], player_pos[1])
		var coord = coordinates()
		#update_tile_visibility(Vector2(coord[0],coord[1]))
	
	# Show/hide player map
	if Input.is_action_just_pressed("number_2"):
		# Update player position
		#var x = int(floor(get_parent().get_node("player_ship_1").get_translation().x))
		#var z = int(floor(get_parent().get_node("player_ship_1").get_translation().z))
		#$PlayerMap/PlayerIcon.position = Vector2(player_pos[0], player_pos[1])*tile_ratio
		$PlayerMap.visible = !$PlayerMap.visible
	if $PlayerMap.visible:
		var player_pos = non_round_coordinates()
		$PlayerMap/PlayerIcon.position = Vector2(player_pos[0], player_pos[1])*tile_ratio
		$PlayerMap/PlayerIcon.rotation = -player_pos[2].y # + PI/2


func update_tile_visibility(pos):
	#print(origin, map_info[origin.substr(4,5)], map_info[origin.substr(6,7)])
	#print('pos ', pos)
	map[pos.x][pos.y]['visited'] = true
	print('updated')
	# Show sea tile
	#var sea_tiles = $PlayerMap/SeaTiles.get_children()
	#sea_tiles[pos.x*level_size + pos.y].visible = false
	var player_pos_vec = Vector2(pos.x, pos.y)
	for tile in $PlayerMap/SeaTiles.get_children():
		if tile.pos == player_pos_vec:
			tile.visible = false
	for tile in $PlayerMap/IslandTiles.get_children():
		#print(tile.pos)
		if tile.pos == player_pos_vec:
			tile.visible = true
	


func create_player_map():	
	# Add water tiles
	var this_scale = Vector2(.78, .4)  # TODO get this automatic from level_size
	var island_scale = .5 # TODO get this automatic from tile_size
	for x in range(level_size-1, 0, -1):
		for z in range(level_size):
			# Make sea
			var new_icon = IconSea.instance()
			new_icon.position = Vector2(x, z)*tile_ratio
			new_icon.scale *= this_scale
			new_icon.pos = Vector2(x, z)
			$PlayerMap/SeaTiles.add_child(new_icon)
			# Add island, if any on this tile
			#print('x ', x, ', z ', z, ', combo ', x*level_size + z)
			var map_idx = x*level_size + z
			var biome_type = biome_list[x*level_size + z]
			if biome_type > 0:
				var new_island = icon_list[biome_type].instance()
				#var disp_vec = Vector2(cos(map[x][z]['rotation']*360), sin(map[x][z]['rotation']*360))*map[x][z]['x_disp']
				#new_island.position = (Vector2(x-.5, z+.2)+disp_vec)
				#new_island.position = (Vector2(x-.5, z+.2)+disp_vec)*tile_ratio
				new_island.position = Vector2(x-.5, z+.2)*tile_ratio
				#var displacement_vec = Vector2(cos(deg2rad(map[x][z]['rotation'])), sin(deg2rad(map[x][z]['rotation'])))*map[x][z]['x_disp']/tile_size*tile_ratio
				#print(displacement_vec)
				#new_island.position = Vector2(x-.5, z+.2)*tile_ratio + displacement_vec #Vector2(map[x][z]['x_disp'], 0)
				new_island.scale *= this_scale * island_scale
				new_island.pos = Vector2(x, z)
				new_island.visible = false
				$PlayerMap/IslandTiles.add_child(new_island)
				island_holder[x*level_size + z] = biome_list[x*level_size + z]

extends Spatial

export var map_size = Vector2(100, 100)
export var number_of_islands = 10 # Careful with increasing this, might not find feasible solution and not start

var island_instance = preload("res://islands//Island.tscn")
var safety_distance = 20 # Careful with increasing this, might not find feasible solution and not start
var map_margin = safety_distance/2.0

func _ready():
	map_size -= Vector2(map_margin, map_margin)
	randomize()
	#create_map()

func _process(delta):
	$Control/VBoxContainer/HBoxContainer/FPS.text = str(Engine.get_frames_per_second())

func create_map():
	print('Generating new map...')
	for i in range(number_of_islands):
		# Find appropriate spot for new island
		var safety_distance_flag = false
		var new_pos = Vector3()
		while !safety_distance_flag:
			# Get random map position
			new_pos = Vector3((randf()*map_size.x)-map_size.x/2, 0, round(randf()*map_size.y)-map_size.y/2) #round(randf()*map_size.y)) 
			# Is this position away from already placed islands? TEMP only for X
			safety_distance_flag = true
			for placed_island in get_tree().get_nodes_in_group("island"):
				if (new_pos-placed_island.global_transform.origin).length() < safety_distance:
					# If any island is too close to new island, stay on while loop and get new position
					safety_distance_flag = false
					break
		add_island(new_pos)
	print('Map generated')

func add_island(pos):
	var new_island = island_instance.instance()
	new_island.global_transform.origin = pos
	new_island.rotate_y(2*PI*randf())
	$Land.add_child(new_island)

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("exit"):
		get_tree().quit()


extends Spatial

export var map_size = Vector2(100, 100)
export var number_of_islands = 10

var island_instance = preload("res://Island.tscn")
var safety_distance = 5

func _ready():
	randomize()
	create_map()

func create_map():
	for i in range(number_of_islands):
		# Find appropriate spot for new island
		var safety_distance_flag = false
		var new_pos = Vector3()
		while !safety_distance_flag:
			# Get random map position
			new_pos = Vector3(round(randf()*map_size.x)-map_size.x/2, randf(), round(randf()*map_size.y)-map_size.y/2) #round(randf()*map_size.y)) 
			# Is this position away from already placed islands? TEMP only for X
			safety_distance_flag = true
			for placed_island in get_tree().get_nodes_in_group("island"):
				if (abs(placed_island.global_transform.origin.x - new_pos.x) < safety_distance) and (abs(placed_island.global_transform.origin.z - new_pos.y) < safety_distance) :
					safety_distance_flag = false
					break
		add_island(new_pos)

func add_island(pos):
	var new_island = island_instance.instance()
	new_island.global_transform.origin = pos
	$Land.add_child(new_island)


func _on_Timer_timeout():
	get_tree().reload_current_scene()

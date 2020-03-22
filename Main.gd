extends Spatial

func _ready():
	#randomize()
	pass

func _process(delta):
	$Control/VBoxContainer/HBoxContainer/FPS.text = str(Engine.get_frames_per_second())
	if Input.is_action_just_pressed("number_3"):
		var coord = $MapHandler.coordinates()
		print('Player pos: ', $Player.transform.origin, 
			' , Player pos in map: ', coord, 
			' , Tile style: ', $MapHandler.map[coord[0]][coord[1]]['biome'], 
			' , Tile pos ', $MapHandler.map[coord[0]][coord[1]]['tile_pos'])
		var bcoord = $MapHandler.better_coordinates()
		print('PLAYER pos: ', $Player.transform.origin, 
			' , Player pos in map: ', bcoord, 
			' , Tile style: ', $MapHandler.map[bcoord[0]][bcoord[1]]['biome'], 
			' , Tile pos ', $MapHandler.map[bcoord[0]][bcoord[1]]['tile_pos'])
		print('\n')


func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

# TODO 
func move_player_to(player_start_pos):
	$Player.global_transform.origin.x = player_start_pos.x
	$Player.global_transform.origin.z = player_start_pos.y
	$Water.global_transform.origin.x = player_start_pos.x
	$Water.global_transform.origin.z = player_start_pos.y

extends Spatial

func _ready():
	pass

func _process(delta):
	$Control/VBoxContainer/HBoxContainer/FPS.text = str(Engine.get_frames_per_second())
	if Input.is_action_just_pressed("number_3"):
		var coord = $MapHandler.coordinates()
		print('Player pos: ', $Player.transform.origin, ',  Tile pos: ', coord, '  , Tile style: ', $MapHandler.map[coord[0]][coord[1]]['biome'])
		#print($MapHandler.map)

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

# TODO 
func move_player_to(player_start_pos):
	$Player.global_transform.origin.x = player_start_pos.x
	$Player.global_transform.origin.z = player_start_pos.y
	$Water.global_transform.origin.x = player_start_pos.x
	$Water.global_transform.origin.z = player_start_pos.y

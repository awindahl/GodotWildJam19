extends Spatial

func _ready():
	var mid_level = 25*15/2.2
	var origin = Vector3(mid_level, 0, mid_level)
	$Player.transform.origin = origin
	$Water.transform.origin = origin

func _process(delta):
	$Control/VBoxContainer/HBoxContainer/FPS.text = str(Engine.get_frames_per_second())
	if Input.is_action_just_pressed("number_3"):
		var coord = $MapHandler.coordinates()
		print('Player pos: ', $Player.transform.origin, ',  Tile pos: ', coord, '  , Tile style: ', $MapHandler.map[coord[0]][coord[1]]['biome'])
		#print($MapHandler.map)

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("number_2"):
		pass
		#$HUD/MapPanel.visible = !$HUD/MapPanel.visible


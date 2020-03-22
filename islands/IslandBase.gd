extends Spatial

export var is_island = true
export var distance_to_center = 0.0
export var rotation_y = 0.0
var info = []
var tile_size
var shop_open = false
var player

func _input(event):
	if Input.is_action_pressed("exit"):
		$Shop.visible = false
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player = null
		

func add_info(tile_info):
	info = tile_info
	tile_size = info['tile_size']
	#var level_size = 15
	
	#var x = floor(get_translation().x)
	#var z = floor(get_translation().z)
	#x = round(fposmod(x / tile_size, level_size))
	#z = round(fposmod(z / tile_size, level_size))
	#info['tile_pos'] = Vector2(x, z)
	
	if info['visited']:
		open_chest()
	else:
		close_chest()
	#$LandPivot/Land.transform.origin += Vector3(tile_size/2.0, 0, tile_size/2.0) # info['x_disp']
	#$LandPivot/Land.transform.origin += Vector3(-tile_size, 0, -tile_size) # info['x_disp']
	#$LandPivot.rotation_degrees = Vector3(0, tile_info['rotation'], 0)

func close_chest():
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_closed.visible = true
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_open.visible = false

func open_chest():
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_closed.visible = false
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_open.visible = true

func open_shop():
	$Shop.visible = true

func _on_AreaMusic_body_entered(body):
	if body.is_in_group("player"):
		Jukebox.update_near_island(1)

func _on_AreaMusic_body_exited(body):
	if body.is_in_group("player"):
		Jukebox.update_near_island(-1)
		
func _process(delta):
	for body in $LandPivot/Land/AreaDocking.get_overlapping_bodies():
		#print('Body ', body.name, ' enter in Area ', name, ', is player? ', body.is_in_group("Player"), ', visited? ', info['visited'])
		if body.is_in_group("Player") and body.get_node("Controller").movement.length() < 0.05 and shop_open == false:
			shop_open = true
			open_shop()
			
			if !info['visited']:
				info['visited'] = true
				print('New land discovered, GET RELIC at ', info['tile_pos'], ', player at ', get_tree().get_nodes_in_group("map_handler")[0].better_coordinates())
				open_chest()
				get_tree().call_group("map_handler", 'update_tile_visibility', info['tile_pos'])

			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			player = body
			print('My pos is ', info['tile_pos'])
			
#func _on_AreaDocking_body_entered(body):
#	print('Body ', body.name, ' enter in Area ', name, ', is player? ', body.is_in_group("Player"), ', visited? ', info['visited'])
#	if body.is_in_group("Player") and !info['visited']:
#		info['visited'] = true
#		print('New land discovered, GET RELIC')
#		open_chest()
#		get_tree().call_group("map_handler", 'update_tile_visibility', info['tile_pos'])
#		open_shop()

func _on_RelicButton_pressed():
	pass # Replace with function body.


func _on_HealButton_pressed():
	player.health += 10
	player.gold -= 1000


func _on_UpgradeButton_pressed():
	print(player.gold)

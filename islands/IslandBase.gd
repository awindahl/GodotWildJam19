extends Spatial

export var is_island = true
export var distance_to_center = 0.0
export var rotation_y = 0.0
var info = []
var tile_size = 1

func add_info(tile_info):
	info = tile_info
	if info['visited']:
		open_chest()
	else:
		close_chest()
	#$LandPivot/Land.transform.origin.x += info['x_disp']*.8*tile_size/2.0
	#$LandPivot.rotation_degrees = Vector3(0, tile_info['rotation']*360, 0)

func close_chest():
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_closed.visible = true
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_open.visible = false

func open_chest():
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_closed.visible = false
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_open.visible = true

func _on_AreaMusic_body_entered(body):
	if body.is_in_group("player"):
		Jukebox.update_near_island(1)

func _on_AreaMusic_body_exited(body):
	if body.is_in_group("player"):
		Jukebox.update_near_island(-1)

func _on_AreaDocking_body_entered(body):
	#print('Body ', body.name, ' enter in Area ', name, ', is player? ', body.is_in_group("player"), ', visiter? ', info['visited'])
	if body.is_in_group("player") and !info['visited']:
		print('New land discovered, GET RELIC')
		open_chest()
		get_tree().call_group("map_handler", 'update_tile_visibility', info['tile_pos'])

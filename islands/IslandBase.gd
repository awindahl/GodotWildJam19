extends StaticBody

export var is_island = true
export var distance_to_center = 0.0
export var rotation_y = 0.0
var info = []
var tile_size = 1

signal visited

func add_info(tile_info):
	info = tile_info
	if info[0]:
		open_chest()
	else:
		close_chest()

	$LandPivot/Land.transform.origin.x += tile_info[1]*.8*tile_size
	$LandPivot.rotation_degrees = Vector3(0, tile_info[2]*360, 0)

func _on_Area_body_entered(body):
	if !info[0] and body.is_in_group('player'):
		open_chest()
		get_tree().call_group("map_handler", 'update_tile_visibility', info[3])

func close_chest():
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_closed.visible = true
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_open.visible = false

func open_chest():
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_closed.visible = false
	$LandPivot/Land/ChestPosition/Chest/treasure_chest_open.visible = true


func _on_AreaMusic_body_entered(body):
	if body.is_in_group("player"):
		Jukebox.update_islands_in_range(1)

func _on_AreaMusic_body_exited(body):
	if body.is_in_group("player"):
		Jukebox.update_islands_in_range(-1)

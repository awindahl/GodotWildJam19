extends Spatial

export var visited = false
export var distance_to_center = 0.0
export var rotation_y = 0.0
var tile_pos = Vector2()

signal visited

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func add_info(tile_info):
	$LandPivot/Land/Pole.visible = tile_info[0]
	$LandPivot/Land.transform.origin.x += tile_info[1]*.8
	$LandPivot.rotation_degrees = Vector3(0, tile_info[2]*360, 0)
	tile_pos = tile_info[3]

func _on_Area_body_entered(body):
	if !$LandPivot/Land/Pole.visible and body.is_in_group('player'):
		Jukebox.dock_on_port()
		$LandPivot/Land/Pole.visible = true
		get_tree().call_group("map_handler", 'update_tile_visibility', tile_pos)


func _on_AreaMusic_body_entered(body):
	if body.is_in_group("player"):
		Jukebox.update_near_island(1)


func _on_AreaMusic_body_exited(body):
	if body.is_in_group("player"):
		Jukebox.update_near_island(-1)


func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		Jukebox.leave_port()

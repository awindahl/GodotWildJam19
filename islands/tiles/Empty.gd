extends Spatial

var info = []


func add_info(tile_info):
	info = tile_info


func _on_Empty_body_entered(body):
	if body.is_in_group("player") and !info['visited']:
		info['visited'] = true
		print('Empty tile discovered')
		get_tree().call_group("map_handler", 'update_tile_visibility', info['tile_pos'])


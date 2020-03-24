extends StaticBody

var info = []

func add_info(tile_info):
	info = tile_info
	
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		Global.dialogue_string = 20
		get_tree().change_scene("res://chirple/DaltongaCutscene.tscn")

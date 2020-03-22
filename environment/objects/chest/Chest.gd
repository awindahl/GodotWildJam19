extends Spatial


func _ready():
	$treasure_chest_closed.visible = true
	$treasure_chest_open.visible = false

func open_chest():
	$treasure_chest_closed.visible = false
	$treasure_chest_open.visible = true

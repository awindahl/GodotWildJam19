extends KinematicBody

const TYPE = "PLAYER"

var health = 10
var gold = Global.player_gold
export var level = 1
var temp = false

var relics = Global.player_relics_found

func _process(delta):
	
	relics = Global.player_relics_found
	
	if health > 10:
		health = 10

	gold = Global.player_gold
	
	if Input.is_action_just_pressed("m"):
		if temp:
			temp = false
		else:
			temp = true
		$HUD._on_MapHandler_toggle_player_map(temp)
	
	$HUD.set_relics_collected(relics)
	$HUD.set_health(health)

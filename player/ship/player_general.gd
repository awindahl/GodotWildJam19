extends KinematicBody

const TYPE = "PLAYER"

var health = 10
var gold = Global.player_gold
export var level = 1


func _process(delta):
	
	if health > 10:
		health = 10

	gold = Global.player_gold

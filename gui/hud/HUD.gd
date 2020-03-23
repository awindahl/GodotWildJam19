extends Control

var health = 100 setget set_health
var money = 0 setget set_money
var speed = 0 setget set_speed

var relics_collected = 0 setget set_relics_collected

onready var health_label = $Mainpanel/HealthLabel
onready var money_label = $Mainpanel/MoneyLabel

onready var relics_label = $RibbonsPanel/Relic/RelicCounterLabel

func _ready():
	$MapPanel.visible = false

func set_health(h):
	health = int(h)
	health_label.text = str(health)

func set_money(m):
	money = int(m)
	money_label.text = str(money)

func set_speed(s):
	speed = int(s)

func _on_MapHandler_player_map(player_pos, player_rot):
	print("player_map ", player_pos, player_rot)
	$MapPanel.update_player(player_pos, player_rot)

func _on_MapHandler_toggle_player_map(value):
	$MapPanel.visible = value

func set_relics_collected(r):
	relics_collected = int(r)
	relics_label.text = str(relics_collected)

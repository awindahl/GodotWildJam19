extends Control

var health = 100 setget set_health
var money = 0 setget set_money
var speed = 0 setget set_speed
var ribbons_collected = 0 setget set_ribbons_collected

onready var health_label = $Mainpanel/HealthLabel
onready var money_label = $Mainpanel/MoneyLabel

onready var ribbons_panel = $RibbonsPanel
onready var ribbons = $RibbonsPanel/VBoxContainer.get_children()
onready var ribbons_tween = $RibbonsPanel/Tween

func set_health(h):
	health = int(h)
	health_label.text = str(health)

func set_money(m):
	money = int(m)
	money_label = str(money)

func set_speed(s):
	speed = int(s)

func set_ribbons_collected(r):
	if r > ribbons_collected:
		ribbons_collected = r
		#move ribbon panel with tween
		#load ribbon icon

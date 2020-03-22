extends Control

var IconSea = load("res://map/2d/icons/Sea.tscn")
var IconI1 = load("res://map/2d/icons/I1.tscn")
var IconI2 = load("res://map/2d/icons/I2.tscn")
var IconI3 = load("res://map/2d/icons/I3.tscn")
var IconI4 = load("res://map/2d/icons/I4.tscn")

export var level_size = 10
export var tile_size = 10
export var number_of_islands = 0 
export var map = []
export var info = []


func create_player_map():
	print('lvl s ', level_size, ', tile s ', tile_size, ', isl n ', number_of_islands)
	
	# Add water tiles
	for x in range(level_size):
		for z in range(level_size):
			var new_icon = IconSea.instace()
			new_icon.position = Vector2(x, z)
			$SeaTiles.add_child(new_icon)
	# Add island tiles
	
	# Move player 
	

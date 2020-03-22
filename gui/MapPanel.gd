extends TextureRect

onready var water_map : TileMap  = $Map/WaterMap
onready var island_map : TileMap = $Map/IslandMap

const TILE_HIDDEN = 1
const TILE_DISCOVERED = 0

const TILE_ISLAND = 0
const TILE_SAND = 1
const TILE_SHOP = 2
const TILE_DALTONGA = 3

const level_size = 15
var tile_ratio = 1

func _ready():
	tile_ratio = Vector2(-$Map/PlayerOrigin.margin_left + $Map/PlayerOrigin.margin_right, \
		-$Map/PlayerOrigin.margin_top + $Map/PlayerOrigin.margin_bottom)/level_size
	for x in range(level_size):
		for y in range(level_size):
			$Map/WaterMap.set_cell(x, y, TILE_HIDDEN)
			$Map/IslandMap.set_cell(x, y, -1)

func show_water(pos):
	$Map/WaterMap.set_cell(pos.x, pos.y, TILE_DISCOVERED)

func show_island(pos, name_type):
	var idx = 0
	if name_type == "SandIsland":
		idx = TILE_SAND
	elif name_type == "Island1":
		idx = TILE_ISLAND
	elif name_type == "DaltongaIsland":
		idx = TILE_DALTONGA
	else:
		idx = TILE_SHOP
	$Map/IslandMap.set_cell(pos.x, pos.y, idx)
	show_water(pos)

func update_player(pos, rot):
	print('map pos ', pos)
	$Map/PlayerOrigin/Player.position = Vector2(pos[0], pos[1])*tile_ratio
	$Map/PlayerOrigin/Player.rotation_degrees = rot.y
	

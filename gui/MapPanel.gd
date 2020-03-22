extends TextureRect

onready var water_map : TileMap  = $Map/WaterMap
onready var island_map : TileMap = $Map/IslandMap

const TILE_HIDDEN = 0
const TILE_DISCOVERED = 1

const TILE_ISLAND = 0
const TILE_SAND = 1
const TILE_SHOP = 2
const TILE_DALTONGA = 3

extends Node2D

const TILE_SIZE = 64
const LEVEL_SIZES = [
	Vector2(40, 25)
]

var map = []

enum Tile {Floor, Wall, Stone, Door, Hole}

onready var tile_map = $TileMap

var level_num = 0
var level_size

func _ready():
	OS.set_window_size(Vector2(1280, 720))
	
	build_level()

func build_level():
	level_size = LEVEL_SIZES[level_num]
	#Set stone
	for x in range(level_size.x):
		map.append([])
		for y in range(level_size.y):
			map[x].append(Tile.Stone)
			tile_map.set_cell(x,y,Tile.Stone)
			
	#Set walls
	add_walls()
	
	#set floor
	add_floor()
	
func add_floor():
	#Bottom left
	tile_map.set_cell(4,19,Tile.Floor)
	#Up left
	tile_map.set_cell(4,4,Tile.Floor)
	#Bottom right
	tile_map.set_cell(35,19,Tile.Floor)
	#Up right
	tile_map.set_cell(35,4,Tile.Floor)
	
	for y in range (16):
		for x in range (32):
			tile_map.set_cell(x+4, y+4, Tile.Floor)
	
	
func add_walls():
	#Bottom left
	tile_map.set_cell(3,20,Tile.Wall)
	#Up left
	tile_map.set_cell(3,3,Tile.Wall)
	#Bottom right
	tile_map.set_cell(36,20,Tile.Wall)
	#Up right
	tile_map.set_cell(36,3,Tile.Wall)
	
	for y in range(17):
		tile_map.set_cell(3, y+3, Tile.Wall)
		tile_map.set_cell(36, y+3, Tile.Wall)
	
	for x in range(33):
		tile_map.set_cell(x+3, 20, Tile.Wall)
		tile_map.set_cell(x+3, 3, Tile.Wall)

func set_tile(x, y, type):
	map[x][y] = type
	tile_map.set_cell(x, y, type)

extends Node2D

const TILE_SIZE = 64
const LEVEL_SIZES = [
	Vector2(16, 32)
]

var map = []

enum Tile {Floor, Wall, Stone, Door, Hole}

onready var tile_map = $TileMap

var level_num = 0
var level_size
var score := 0
var player_tile

func get_player():
	return $PlayerManager.get_player_if_there()

func _ready():
	#OS.set_window_size(Vector2(1280, 720))
	
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
	
	#Place player
	$PlayerManager.spawn_player()
	var player_x = 20
	var player_y = 20
	player_tile = Vector2(player_x, player_y)
	
func add_floor():
	#Bottom left
	tile_map.set_cell(2,30,Tile.Floor)
	#Up left
	tile_map.set_cell(2,2,Tile.Floor)
	#Bottom right
	tile_map.set_cell(13,30,Tile.Floor)
	#Up right
	tile_map.set_cell(13,2,Tile.Floor)
	
	for y in range (11):
		for x in range (28):
			tile_map.set_cell(x+2, y+2, Tile.Floor)
	
	
func add_walls():
	#Bottom left
	tile_map.set_cell(1,31,Tile.Wall)
	#Up left
	tile_map.set_cell(1,1,Tile.Wall)
	#Bottom right
	tile_map.set_cell(14,31,Tile.Wall)
	#Up right
	tile_map.set_cell(14,1,Tile.Wall)
	
	for y in range(30):
		tile_map.set_cell(1, y+2, Tile.Wall)
		tile_map.set_cell(31, y+1, Tile.Wall)

	for x in range(13):
		tile_map.set_cell(x+2, 1, Tile.Wall)
		tile_map.set_cell(x+2, 14, Tile.Wall)

func set_tile(x, y, type):
	map[x][y] = type
	tile_map.set_cell(x, y, type)

func update_UI():
	pass
#	$CanvasLayer/HPLabel.text = str(get_player().health)
#	$CanvasLayer/ScoreLabel.text = "Score: " + str(score)

#
#	if get_player().has_item(0):
#		print("PLAYER HAS THE ITEM")
#		$CanvasLayer/WeaponSlot.texture = load("res://art/DiceHammer.png")
#	else:
#		$CanvasLayer/WeaponSlot.texture = load("res://art/BlankHammer.png")
#
#	if get_player().has_item(1):
#		$CanvasLayer/ShieldSlot.texture = load("res://art/Shield.png")
#	else:
#		$CanvasLayer/ShieldSlot.texture = load("res://art/BlankShield.png")
	

func update_visuals():
	get_player().tween_to(player_tile * TILE_SIZE)
#	$EnemyManager.turn()
	# Visibility Map Stuff

	var player_center = tile_to_pixel_center(player_tile.x, player_tile.y)
	var space_state = get_world_2d().direct_space_state
	
					
func tile_to_pixel_center(x, y):
	return Vector2((x + 0.5) * TILE_SIZE, (y + 0.5) * TILE_SIZE)

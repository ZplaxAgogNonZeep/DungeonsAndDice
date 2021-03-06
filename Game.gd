extends Node2D

const TILE_SIZE = 64
onready var empty = preload("res://art/black.png")
onready var hammer = preload("res://art/hammer.png")

#Level Sizes constants, tweak as needed
const LEVEL_SIZES = [
	Vector2(30,30),
	Vector2(35,35),
	Vector2(40,40),
	Vector2(45,45),
	Vector2(50,50),
]

#Defining room stats, tweak as needed
const LEVEL_ROOM_COUNTS = [5,7,9,12,15]
const MIN_ROOM_DIMENSION = 5
const MAX_ROOM_DIMENSION = 8

#Different tile names/types 	TODO: implement multiple versions of types. Wall1, Wall2, etc.
#enum Tile {Wall, Door, Floor, Ladder, Stone}
enum Tile {Floor, Wall, Stone, Door, Hole}

# Current Level --------------------------------------

var level_num = 0
var map = []
var rooms = []
var level_size

# Audio Variables ==================================================================================
var music_volume = -12
var sfx_volume = -12

# Node refs ----------------------------------------------

onready var tile_map = $TileMap
onready var visiblility_map = $VisibilityMap
#onready var player = $Player

# Getters and Setters ----------------------------------------------------------

func get_player():
	return $PlayerManager.get_player_if_there()

func get_enemies() -> Array:
	return $EnemyManager.get_children()

func get_items(type : int) -> Array:
	if type == 3:
		return $ItemManager.get_children()
	else:
		var item_list = []
		for i in range($ItemManager.get_child_count()):
			if $ItemManager.get_child(i).item_type == type:
				item_list.append($ItemManager.get_child(i))
		return item_list
	

# UI Commands ======================================================================================

func update_UI():
	$CanvasLayer/HPLabel.text = str(get_player().health)
	$CanvasLayer/ScoreLabel.text = "Score: " + str(score)

	
	if get_player().has_item(0):
		print("PLAYER HAS THE ITEM")
		$CanvasLayer/WeaponSlot.texture = load("res://art/DiceHammer.png")
	else:
		$CanvasLayer/WeaponSlot.texture = load("res://art/BlankHammer.png")
	
	if get_player().has_item(1):
		$CanvasLayer/ShieldSlot.texture = load("res://art/Shield.png")
	else:
		$CanvasLayer/ShieldSlot.texture = load("res://art/BlankShield.png")
	

# Game State ---------------------------------------------

var player_tile #Tile the player is currently on
var score := 0
var enemy_pathfinding

# Called when the node enters the scene tree for the first time.
func _ready():
	#Scaling for pixel art, not perfect
	OS.set_window_size(Vector2(1024, 600)) #Vector2(1280, 720))
	
	# Audio Sounds :) ==============================================================================
	$AudioManager.startTrack("FrogSong", 1, true)
	
	
	#Build random level
	randomize()
	build_level()
	

func go_to_next_level():
	# Called when the player enters a hole, builds a new level and increases score
	level_num += 1
	score += 20
	if level_num < LEVEL_SIZES.size():
		build_level()
		yield(get_tree(), "idle_frame")
		get_player().try_move(1,0)
	else:
#		score += 1000
#		$CanvasLayer/Win.visible = true
		get_tree().change_scene("res://BossFight.tscn")

func build_level():
	
	# Clearing previous map
	rooms.clear()
	map.clear()
	tile_map.clear()
	$EnemyManager.removeEnemies() 
	$ItemManager.removeItems()
	
	enemy_pathfinding = AStar.new() #NOTE: livi mess
	
	#Fill entire level with Stone
	level_size = LEVEL_SIZES[level_num]
	for x in range(level_size.x):
		map.append([])
		for y in range(level_size.y):
			map[x].append(Tile.Stone)
			tile_map.set_cell(x,y,Tile.Stone)
			visiblility_map.set_cell(x, y, 0)
			
	#Always have a border of 2 (tweakable) stone around the map. No rooms in this ring
	var free_regions = [Rect2(Vector2(2,2), level_size - Vector2(4,4))]
	var num_rooms = LEVEL_ROOM_COUNTS[level_num]
	for i in range(num_rooms):
		add_room(free_regions)
		if free_regions.empty():
			break
			
	connect_rooms()
	
	#Place player
	$PlayerManager.spawn_player()
	var start_room = rooms.front()
	var player_x = start_room.position.x + 1 + randi() % int(start_room.size.x - 2)
	var player_y = start_room.position.y + 1 + randi() % int(start_room.size.y - 2)
	player_tile = Vector2(player_x, player_y)

	#update_visuals() #Must call after physics is dealt with
	call_deferred("update_visuals")
	
	#Place enemies
	$EnemyManager.placeEnemies() 
	
	#Place items
	$ItemManager.place_items()
	
	#Place end hole
	var end_room = rooms.back()
	var hole_x = end_room.position.x + 1 + randi() % int(end_room.size.x - 2)
	var hole_y = end_room.position.y + 1 + randi() % int(end_room.size.y - 2)
	set_tile(hole_x, hole_y, Tile.Hole)
	
	#Display what level the player is on
	$CanvasLayer/LevelLabel.text = "Level: " + str(level_num)
	
func clear_path(tile):
	var new_point = enemy_pathfinding.get_available_point_id()
	enemy_pathfinding.add_point(new_point, Vector3(tile.x, tile.y, 0))
	var points_to_connect = []
	
	if tile.x > 0 && map[tile.x - 1][tile.y] == Tile.Floor:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x - 1, tile.y, 0)))
	if tile.y > 0 && map[tile.x][tile.y - 1] == Tile.Floor:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x, tile.y - 1, 0)))
	if tile.x < 0 && map[tile.x + 1][tile.y] == Tile.Floor:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x + 1, tile.y, 0)))
	if tile.y < 0 && map[tile.x][tile.y + 1] == Tile.Floor:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x, tile.y + 1, 0)))
		
	for point in points_to_connect:
		enemy_pathfinding.connect_points(point, new_point)
	
func update_visuals():
	get_player().tween_to(player_tile * TILE_SIZE)
#	$EnemyManager.turn()
	# Visibility Map Stuff

	var player_center = tile_to_pixel_center(player_tile.x, player_tile.y)
	var space_state = get_world_2d().direct_space_state
	for x in range(level_size.x):
		for y in range(level_size.y):
			if visiblility_map.get_cell(x, y) == 0:
				var x_dir = 1 if x < player_tile.x else -1
				var y_dir = 1 if y < player_tile.y else -1
				var test_point = tile_to_pixel_center(x, y) + Vector2(x_dir, y_dir) * TILE_SIZE / 2
				
				var occlusion = space_state.intersect_ray(player_center, test_point)
				if !occlusion || (occlusion.position - test_point).length() < 1:
					visiblility_map.set_cell(x, y, -1)
	
	
	#for enemy in get_enemies():
	#	enemy.position = enemy.tile * TILE_SIZE
					
#	$CanvasLayer/Score.text = "Score: " str(score) #TODO: fix livis mess

func tile_to_pixel_center(x, y):
	return Vector2((x + 0.5) * TILE_SIZE, (y + 0.5) * TILE_SIZE)
	
func connect_rooms():
	#Building an AStar graph of the area where we can use pathfinding to make corridors
	
	var stone_graph = AStar.new()
	var point_id = 0
	for x in range(level_size.x):
		for y in range(level_size.y):
			if map[x][y] == Tile.Stone:
				stone_graph.add_point(point_id, Vector3(x, y, 0))
				
				#Connect to left if also stone
				if x > 0 && map[x - 1][y] == Tile.Stone:
					var left_point = stone_graph.get_closest_point(Vector3(x - 1, y, 0))
					stone_graph.connect_points(point_id, left_point)
					
				#Connect to above if also stone
				if y > 0 && map[x][y - 1] == Tile.Stone:
					var above_point = stone_graph.get_closest_point(Vector3(x, y - 1, 0))
					stone_graph.connect_points(point_id, above_point)
					
				point_id += 1
				
	#Build an Astar graph of room connections
	
	var room_graph = AStar.new()
	point_id = 0
	for room in rooms:
		var room_center = room.position + room.size / 2
		room_graph.add_point(point_id, Vector3(room_center.x, room_center.y, 0))
		point_id += 1
		
	#Add random connections until all rooms are connected
	
	while !is_everything_connected(room_graph):
		add_random_connection(stone_graph, room_graph)
		
func is_everything_connected(graph):
	var points = graph.get_points()
	var start = points.pop_back()
	for point in points:
		var path = graph.get_point_path(start, point)
		if !path:
			return false
			
	return true
	
func add_random_connection(stone_graph, room_graph):
	#Pick rooms to connect
	
	var start_room_id = get_least_connected_point(room_graph)
	var end_room_id = get_nearest_unconnected_point(room_graph, start_room_id)
	
	#Pick door locations
	
	var start_position = pick_random_door_location(rooms[start_room_id])
	var end_position = pick_random_door_location(rooms[end_room_id])
	
	# Find a path to connect the doors to each other
	
	var closest_start_point = stone_graph.get_closest_point(start_position)
	var closest_end_point = stone_graph.get_closest_point(end_position)
	
	var path = stone_graph.get_point_path(closest_start_point, closest_end_point)
	assert(path)
	
	# Add path to the map
	
	set_tile(start_position.x, start_position.y, Tile.Door)
	set_tile(end_position.x, end_position.y, Tile.Door)
	
	for position in path:
		set_tile(position.x, position.y, Tile.Floor)
		
	room_graph.connect_points(start_room_id, end_room_id)

	
func get_least_connected_point(graph):
	var point_ids = graph.get_points()
	
	var least
	var tied_for_least = []
	
	for point in point_ids:
		var count = graph.get_point_connections(point).size()
		if !least || count < least:
			least = count
			tied_for_least = [point]
		elif count == least:
			tied_for_least.append(point)
			
	return tied_for_least[randi() % tied_for_least.size()]
	
func get_nearest_unconnected_point(graph, target_point):
	var target_position = graph.get_point_position(target_point)
	var point_ids = graph.get_points()
	
	var nearest
	var tied_for_nearest = []
	
	for point in point_ids:
		if point == target_point:
			continue
		
		var path = graph.get_point_path(point, target_point)
		if path:
			continue
			
		var dist = (graph.get_point_position(point) - target_position).length()
		if !nearest || dist < nearest:
			nearest = dist
			tied_for_nearest = [point]
		elif dist == nearest:
			tied_for_nearest.append(point)
			
	return tied_for_nearest[randi() % tied_for_nearest.size()]
	
func pick_random_door_location(room):
	var options = []
	
	#Top and bottom walls
	
	for x in range(room.position.x + 1, room.end.x - 2):
		options.append(Vector3(x, room.position.y, 0))
		options.append(Vector3(x, room.end.y - 1, 0))
		
	#Left and right walls
	
	for y in range(room.position.y + 1, room.end.y - 2):
		options.append(Vector3(room.position.x, y, 0))
		options.append(Vector3(room.end.x - 1, y, 0))
		
	return options[randi() % options.size()]
			
func add_room(free_regions):
	var region = free_regions[randi() % free_regions.size()]
	
	#Set room to minimum size and then randomly increase size
	var size_x = MIN_ROOM_DIMENSION
	if region.size.x > MIN_ROOM_DIMENSION:
		size_x += randi() % int(region.size.x - MIN_ROOM_DIMENSION)
		
	var size_y = MIN_ROOM_DIMENSION
	if region.size.y > MIN_ROOM_DIMENSION:
		size_y += randi() % int(region.size.y - MIN_ROOM_DIMENSION)
		
	#Constrain to maximum size
	size_x = min(size_x, MAX_ROOM_DIMENSION)
	size_y = min(size_y, MAX_ROOM_DIMENSION)
	
	#Repeat for player start location
	var start_x = region.position.x
	if region.size.x > size_x:
		start_x += randi() % int(region.size.x - size_x)
		
	var start_y = region.position.y
	if region.size.y > size_y:
		start_y += randi() % int(region.size.y - size_y)
		
	#Create Walls around rooms
	var room = Rect2(start_x, start_y, size_x, size_y)
	rooms.append(room)
	
	for x in range(start_x, start_x + size_x):
		set_tile(x, start_y, Tile.Wall)
		set_tile(x, start_y + size_y - 1, Tile.Wall)
		
	for y in range(start_y + 1, start_y + size_y - 1):
		set_tile(start_x, y, Tile.Wall)
		set_tile(start_x + size_x - 1, y, Tile.Wall)
		
		#Fill rooms with floor
		for x in range(start_x +1, start_x + size_x - 1):
			set_tile(x, y, Tile.Floor)
			
	cut_regions(free_regions, room)
	
func cut_regions(free_regions, region_to_remove):
	var removal_queue = []
	var addition_queue = []
	
	for region in free_regions:
		if region.intersects(region_to_remove):
			removal_queue.append(region)
			
			var leftover_left = region_to_remove.position.x - region.position.x - 1
			var leftover_right = region.end.x - region_to_remove.end.x - 1
			var leftover_above = region_to_remove.position.y - region.position.y - 1
			var leftover_below = region.end.y - region_to_remove.end.y - 1
			
			if leftover_left >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(region.position, Vector2(leftover_left, region.size.y)))
			if leftover_right >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(Vector2(region_to_remove.end.x + 1, region.position.y), Vector2(leftover_right, region.size.y)))
			if leftover_above >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(region.position, Vector2(region.size.x, leftover_above)))
			if leftover_below >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(Vector2(region.position.x, region_to_remove.end.y + 1), Vector2(region.size.x, leftover_below)))
			
	for region in removal_queue:
		free_regions.erase(region)
		
	for region in addition_queue:
		free_regions.append(region)
	
func set_tile(x, y, type):
	map[x][y] = type
	tile_map.set_cell(x, y, type)
	
	if type == Tile.Floor:
		clear_path(Vector2(x, y))


func _on_Button_pressed():
	level_num = 0
	score = 0
	build_level()
	$CanvasLayer/Win.visible = false
	$CanvasLayer/Lose.visible = false

extends Node2D

const LEVEL_ENEMY_COUNTS = [5, 8, 12, 18, 26]
const TILE_SIZE = 64

#consts for diff enemy types
const LEVEL_D2_ENEMY_COUNTS = [2, 3, 4, 5, 6]
const LEVEL_D4_ENEMY_COUNTS = [2, 2, 3, 4, 6]
const LEVEL_D6_ENEMY_COUNTS = [1, 2, 2, 3, 4]
const LEVEL_D8_ENEMY_COUNTS = [0, 1, 2, 3, 4]
const LEVEL_D10_ENEMY_COUNTS = [0, 0, 1, 2, 3]
const LEVEL_D12_ENEMY_COUNTS = [0, 0, 0, 1, 6]
const LEVEL_D20_ENEMY_COUNTS = [0, 0, 0, 2, 1]

onready var game = get_tree().root.get_node("Game")
const EnemyScene = preload("res://Enemy/D2Enemy.tscn")

var enemies = []

#class Enemy extends Reference:
#	var sprite_node
#	var tile
#	var full_hp
#	var hp
#	var dead = false
#
#	func _init(game, enemy_level, x, y):
#		full_hp = 1 + enemy_level * 2 #TODO: make final numbers
#		hp = full_hp
#		tile = Vector2(x, y)
#		sprite_node = EnemyScene.instance()
#		sprite_node.frame = enemy_level
#		sprite_node.position = tile * TILE_SIZE
#		game.add_child(sprite_node)
#
#	func remove():
#		sprite_node.queue_free()
#
#	func take_damage(game, dmg):
#		if dead:
#			return
#			# TODO: Tweak values
#		hp = max(0, hp - dmg)
#		sprite_node.get_node("HPBar").rect_size.x = TILE_SIZE * hp / full_hp
#
#		if hp == 0:
#			dead = true
#			game.score += 10 * full_hp



func turn():
	for i in range(get_child_count()):
		get_child(i).new_turn()

# Spawn and Remove Enemy ===========================================================================
func removeEnemies():
	for i in range(get_child_count()):
		get_child(i).queue_free()
	
func placeEnemies():
	placeD2s()
	placeD4s()
	placeD6s()
	placeD8s()
	placeD10s()
	placeD12s()
	placeD20s()

#func enemy_move():
#	for enemy in enemies:
#		enemy.position = enemy.tile * TILE_SIZE
		
		
	
func placeD2s():
	var num_d2_enemies = LEVEL_D2_ENEMY_COUNTS[game.level_num]
	for i in range(num_d2_enemies):
		var room = game.rooms[1 + randi() % (game.rooms.size() - 1)]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		
		
		var blocked = false
		for enemy in get_children():

			if enemy.tile.x == x && enemy.tile.y == y:
				blocked = true
				break
				
		if !blocked:
			var enemy = preload("res://Enemy/D2Enemy.tscn").instance()
			enemy.tile = Vector2(x, y)
			enemy.position = enemy.tile * TILE_SIZE
			add_child(enemy)
	
func placeD4s():
	var num_d4_enemies = LEVEL_D4_ENEMY_COUNTS[game.level_num]
	for i in range(num_d4_enemies):
		var room = game.rooms[1 + randi() % (game.rooms.size() - 1)]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		
		
		var blocked = false
		for enemy in get_children():

			if enemy.tile.x == x && enemy.tile.y == y:
				blocked = true
				break
				
		if !blocked:
			var enemy = preload("res://Enemy/D4Enemy.tscn").instance()
			enemy.tile = Vector2(x, y)
			enemy.position = enemy.tile * TILE_SIZE
			add_child(enemy)
			
func placeD6s():
	var num_d6_enemies = LEVEL_D6_ENEMY_COUNTS[game.level_num]
	for i in range(num_d6_enemies):
		var room = game.rooms[1 + randi() % (game.rooms.size() - 1)]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		
		
		var blocked = false
		for enemy in get_children():

			if enemy.tile.x == x && enemy.tile.y == y:
				blocked = true
				break
				
		if !blocked:
			var enemy = preload("res://Enemy/D6Enemy.tscn").instance()
			enemy.tile = Vector2(x, y)
			enemy.position = enemy.tile * TILE_SIZE
			add_child(enemy)
	
func placeD8s():
	var num_d8_enemies = LEVEL_D8_ENEMY_COUNTS[game.level_num]
	for i in range(num_d8_enemies):
		var room = game.rooms[1 + randi() % (game.rooms.size() - 1)]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		
		
		var blocked = false
		for enemy in get_children():

			if enemy.tile.x == x && enemy.tile.y == y:
				blocked = true
				break
				
		if !blocked:
			var enemy = preload("res://Enemy/D8Enemy.tscn").instance()
			enemy.tile = Vector2(x, y)
			enemy.position = enemy.tile * TILE_SIZE
			add_child(enemy)
	
func placeD10s():
	var num_d10_enemies = LEVEL_D10_ENEMY_COUNTS[game.level_num]
	for i in range(num_d10_enemies):
		var room = game.rooms[1 + randi() % (game.rooms.size() - 1)]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		
		
		var blocked = false
		for enemy in get_children():

			if enemy.tile.x == x && enemy.tile.y == y:
				blocked = true
				break
				
		if !blocked:
			var enemy = preload("res://Enemy/D10Enemy.tscn").instance()
			enemy.tile = Vector2(x, y)
			enemy.position = enemy.tile * TILE_SIZE
			add_child(enemy)
	
func placeD12s():
	var num_d12_enemies = LEVEL_D12_ENEMY_COUNTS[game.level_num]
	for i in range(num_d12_enemies):
		var room = game.rooms[1 + randi() % (game.rooms.size() - 1)]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		
		
		var blocked = false
		for enemy in get_children():

			if enemy.tile.x == x && enemy.tile.y == y:
				blocked = true
				break
				
		if !blocked:
			var enemy = preload("res://Enemy/D12Enemy.tscn").instance()
			enemy.tile = Vector2(x, y)
			enemy.position = enemy.tile * TILE_SIZE
			add_child(enemy)
	
func placeD20s():
	var num_d20_enemies = LEVEL_D20_ENEMY_COUNTS[game.level_num]
	for i in range(num_d20_enemies):
		var room = game.rooms[1 + randi() % (game.rooms.size() - 1)]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		
		
		var blocked = false
		for enemy in get_children():

			if enemy.tile.x == x && enemy.tile.y == y:
				blocked = true
				break
				
		if !blocked:
			var enemy = preload("res://Enemy/D20Enemy.tscn").instance()
			enemy.tile = Vector2(x, y)
			enemy.position = enemy.tile * TILE_SIZE
			add_child(enemy)
	


	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

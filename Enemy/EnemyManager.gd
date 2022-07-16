extends Node2D

const LEVEL_ENEMY_COUNTS = [5, 8, 12, 18, 26]
const TILE_SIZE = 16

onready var game = get_tree().root.get_node("Game")
const EnemyScene = preload("res://Enemy/Enemy.tscn")

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
	var num_enemies = LEVEL_ENEMY_COUNTS[game.level_num]
	for i in range(num_enemies):
		var room = game.rooms[1 + randi() % (game.rooms.size() - 1)]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		
		
		var blocked = false
		for enemy in get_children():

			if enemy.tile.x == x && enemy.tile.y == y:
				blocked = true
				break
				
		if !blocked:
			var enemy = preload("res://Enemy/Enemy.tscn").instance()
			enemy.tile = Vector2(x, y)
			enemy.position = enemy.tile * TILE_SIZE
			add_child(enemy)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

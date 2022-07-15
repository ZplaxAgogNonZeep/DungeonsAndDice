extends Node2D

const LEVEL_ENEMY_COUNTS = [5, 8, 12, 18, 26]
const TILE_SIZE = 16

const EnemyScene = preload("res://Enemy.tscn")

class Enemy extends Reference:
	var sprite_node
	var tile
	var full_hp
	var hp
	var dead = false
	
	func _init(game, enemy_level, x, y):
		full_hp = 1 + enemy_level * 2 #TODO: make final numbers
		hp = full_hp
		tile = Vector2(x, y)
		sprite_node = EnemyScene.instance()
		sprite_node.frame = enemy_level
		sprite_node.position = tile * TILE_SIZE
		game.add_chiled(sprite_node)
		
	func remove():
		sprite_node.queue_free()

var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

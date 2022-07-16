extends Node2D

const TILE_SIZE = 16

const LEVEL_ITEM_COUNTS = [2, 4, 6, 8, 10]

const ItemScene = preload("res://Item/Item.tscn")

onready var game = get_tree().root.get_node("Game")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var items = []

func place_items():
	var num_items = LEVEL_ITEM_COUNTS[game.level_num]
	for i in range(num_items):
		var room = game.rooms[randi() % (game.rooms.size())]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		#items.append(Item.new(self, x, y, randi() % 2 == 0))

		var item = preload("res://Item/Item.tscn").instance()
		item.tile = Vector2(x, y)
		item.position = item.tile * TILE_SIZE
		add_child(item)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

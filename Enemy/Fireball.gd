extends Sprite

var tile

onready var game = get_tree().root.get_node("Game")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func act(player):
	print("act was called")
	var move_tile = Vector2(tile.x, tile.y +1)
	if move_tile == player.game.player_tile:
		player.take_damage(1)
	else:
		var blocked = false
		for enemy in player.game.get_enemies():
			if enemy.tile == move_tile:
				blocked = true
				break
				
		if !blocked:
			
			if (checkDestroy(move_tile)):
				queue_free()
			else:
				tile = move_tile
				tween_to(tile * player.game.TILE_SIZE)
		
func take_damage(game, dmg):
	pass

func checkDestroy(move_tile):
	if (game.Tile.Stone == game.map[move_tile.x][move_tile.y]):
		return true
	else:
		return false

func tween_to(posn : Vector2):
	$Tween.interpolate_property(self, "position", position, posn, .1)
	$Tween.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

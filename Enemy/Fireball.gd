extends Sprite

var tile

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func act(player):
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
			tile = move_tile
			tween_to(tile * player.game.TILE_SIZE)

func tween_to(posn : Vector2):
	$Tween.interpolate_property(self, "position", position, posn, .1)
	$Tween.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

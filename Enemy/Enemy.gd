extends Sprite

# A testing Enemy Script, not sure how we want to do enemy implementation so I'm just kind of testing

var health = 2
var dir = 1

func new_turn():
	yield(get_tree(), "idle_frame")
	$RayCast2D.cast_to = Vector2(15 * dir, 0)
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		dir *= -1
		new_turn()
	else:
		position += Vector2(get_parent().game.TILE_SIZE * dir, 0)

extends Sprite

# A testing Enemy Script, not sure how we want to do enemy implementation so I'm just kind of testing

var health = 2
var dir = 1

func new_turn():
	yield(get_tree(), "idle_frame")
	$RayCast2D.cast_to = Vector2(16 * dir, 0)
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		dir *= -1
		$RayCast2D.cast_to = Vector2(16 * dir, 0)
		$RayCast2D.force_raycast_update()
		if $RayCast2D.is_colliding():
			dir = 0
	tween_to(position + Vector2(get_parent().game.TILE_SIZE * dir, 0))

func tween_to(posn : Vector2):
	$Tween.interpolate_property(self, "position", position, posn, .1)
	$Tween.start()

extends Sprite

# A testing Enemy Script, not sure how we want to do enemy implementation so I'm just kind of testing

var health = 2
var max_health = 2
var dir = 1
var damage = 1

var tile

#var sprite_node
#var tile
#var full_hp
#var hp
#var dead = false

#func _init(game, enemy_level, x, y):
#	full_hp = 1 + enemy_level * 2 #TODO: make final numbers
#	hp = full_hp
#	tile = Vector2(x, y)
#	sprite_node = EnemyScene.instance()
#	sprite_node.frame = enemy_level
#	sprite_node.position = tile * TILE_SIZE
#	game.add_child(sprite_node)

func _ready():
	$HPBar.value = health
	$HPBar.max_value = max_health

func die():
	queue_free()
	
func take_damage(game, dmg):
		# TODO: Tweak values
	health = max(0, health - dmg)
	$HPBar.value = health
	
	
	if health == 0:
		#game.score += 10 * full_hp
		get_parent().game.update_UI()
		die()


func new_turn():
	yield(get_tree(), "idle_frame")
	$RayCast2D.cast_to = Vector2(16 * dir, 0)
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider().is_in_group("Player"):
			$RayCast2D.get_collider().get_parent().take_damage(damage)
		else:
			dir *= -1
			$RayCast2D.cast_to = Vector2(16 * dir, 0)
			$RayCast2D.force_raycast_update()
			if $RayCast2D.is_colliding():
				dir = 0
	tween_to(position + Vector2(get_parent().game.TILE_SIZE * dir, 0))

func tween_to(posn : Vector2):
	$Tween.interpolate_property(self, "position", position, posn, .1)
	$Tween.start()


extends Sprite

# NOTE:
# Hitbox node is in group Player

onready var game = get_tree().root.get_node("Game")

#Different tile names/types 	TODO: implement multiple versions of types. Wall1, Wall2, etc.
#enum Tile {Wall, Door, Floor, Ladder, Stone}
enum Tile {Floor, Wall, Stone, Door, Hole}

# Health Variables
var health = 3
var max_health = 3

var damage = 1

func _ready():
	game.update_UI()

# Controls and Movement ============================================================================

func _input(event):
	if !event.is_pressed():
		return
		
	if event.is_action("Left"):
		try_move(-1, 0)
	elif event.is_action("Right"):
		try_move(1, 0)
	elif event.is_action("Up"):
		try_move(0, -1)
	elif event.is_action("Down"):
		try_move(0, 1)

func try_move(dx, dy):
	var x = game.player_tile.x + dx
	var y = game.player_tile.y + dy
	
	var tile_type = game.Tile.Stone
	if x >= 0 && x < game.level_size.x && y >= 0 && y < game.level_size.y:
		tile_type = game.map[x][y]
	
	$AttackRange.cast_to = Vector2(dx * game.TILE_SIZE, dy * game.TILE_SIZE)
	$AttackRange.force_raycast_update()
	
	if $AttackRange.is_colliding():
		$AttackRange.get_collider().get_parent(.take_damage(damage))
	else:
		match tile_type:
			Tile.Floor:
				var blocked = false #TODO: fix livis mess
				for enemy in game.get_enemies():
					if enemy.tile.x == x && enemy.tile.y == y:
						enemy.take_damage(self, 1)
#						if enemy.dead:
#							enemy.remove()
#							game.get_enemies().erase(enemy)
						blocked = true
						break
						
				if !blocked:
					game.player_tile = Vector2(x, y)
				
			Tile.Door:
				game.set_tile(x, y, Tile.Floor)
				
			Tile.Hole:
				game.go_to_next_level()
				
	for enemy in game.get_enemies():
		enemy.act(self)
			
			
	#update_visuals() #Must call after physics is dealt with
	game.call_deferred("update_visuals")

func tween_to(posn : Vector2):
	# primerally called from update_visuals() to move the player
	# to a new place smoothly
	$Tween.interpolate_property(self, "position", position, posn, .1)
	$Tween.start()

# Health and Dying =================================================================================
func take_damage(dam : int):
	# Reduces health value by given int, if the variable 
	# is bigger than current health, calls die()
	print("Player taking damage equal to: " + str(dam))
	if dam < health:
		health -= dam
		game.update_UI()
	else:
		health = 0
		game.update_UI()
		die()
	

func die():
	#deletes the node and notifies the system
	game._on_Button_pressed() # This is very dangrous
	game.get_node("CanvasLayer/Lose").visible = true
	queue_free()
	

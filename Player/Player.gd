extends AnimatedSprite

# NOTE:
# Hitbox node is in group Player

onready var game = get_tree().root.get_node("Game")

#Different tile names/types 	TODO: implement multiple versions of types. Wall1, Wall2, etc.
#enum Tile {Wall, Door, Floor, Ladder, Stone}
enum Tile {Floor, Wall, Stone, Door, Hole}

# Health Variables
var health = 6
var max_health = 6

var damage #= 1
var defense = 0

var hasPlayerMoved = false

func _ready():
	game.update_UI()

# Controls and Movement ============================================================================

func _input(event):
	#hasPlayerMoved = false
	if !event.is_pressed():
		return
		
	if event.is_action("Left"):
		animation = "WalkLeft"
		try_move(-1, 0)
	elif event.is_action("Right"):
		animation = "WalkRight"
		try_move(1, 0)
	elif event.is_action("Up"):
		animation = "WalkUp"
		try_move(0, -1)
	elif event.is_action("Down"):
		animation = "WalkDown"
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
		$AttackRange.get_collider().get_parent($AttackRange.get_collider().take_damage(damage))
	else:
		match tile_type:
			Tile.Floor:
				var blocked = false #TODO: fix livis mess
				for enemy in game.get_enemies():
					if enemy.tile.x == x && enemy.tile.y == y:
						var damage_value = rolldice(6)
						game.get_node("DamageNumberManager").show_value(enemy.position, damage_value, true)
						enemy.take_damage(self, damage_value)
						game.goodEnding = false
						if has_item(0):
							remove_item(0)

						blocked = true
						break
				if !blocked:
					game.player_tile = Vector2(x, y)
					for i in range(game.get_items(3).size()):
						if game.get_items(3)[i].tile == game.player_tile and not has_item(game.get_items(3)[i].item_type):
							print(has_item(game.get_items(3)[i].item_type))
							game.get_node("ItemManager").pick_up_item_at(self, i)
							break
				
			Tile.Door:
				game.set_tile(x, y, Tile.Floor)
				
			Tile.Hole:
				game.go_to_next_level()
				

			
			
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
	
	if dam - defense < health:
		health -= dam - defense
		game.get_node("DamageNumberManager").show_value(position, dam - defense, false)
		game.update_UI()
	else:
		health = 0
		game.update_UI()
		die()
	
	if has_item(1):
		remove_item(1)


func die():
	#deletes the node and notifies the system
	game._on_Button_pressed() # This is very dangrous
	game.get_node("CanvasLayer/Lose").visible = true
	queue_free()



func _on_Tween_tween_completed(object, key):

	for enemy in game.get_enemies():
		enemy.act(self)

# Item Stuff =======================================================================================

func add_item(item):
	var new_item = item.instance()
	var item_name = new_item.item_name
	$Inventory.add_child(new_item)
	
	for i in range($Inventory.get_child_count()):
		if $Inventory.get_child(i).item_name == item_name:
			$Inventory.get_child(i).equip()
	
	game.update_UI()
		

func has_item(type : int) -> bool:
	for i in range($Inventory.get_child_count()):
		if $Inventory.get_child(i).item_type == type:
			return true
	return false

func remove_item(type : int):
	print("REMOVING ITEM")
	for i in range($Inventory.get_child_count()):
		print("checking types:")
		print($Inventory.get_child(i).item_type)
		print(type)
		if $Inventory.get_child(i).item_type == type:
			$Inventory.get_child(i).unequip()
			$Inventory.get_child(i).queue_free()
	yield(get_tree(), "idle_frame")
	game.update_UI()
	
func rolldice(sides):
	var roll = randi() % sides + 1
	
	if (has_item(0)):
		roll += randi() % sides + 1
	
	print("Player rolled ", roll)
	return roll

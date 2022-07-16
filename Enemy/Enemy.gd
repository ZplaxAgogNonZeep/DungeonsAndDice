extends Sprite

# A testing Enemy Script, not sure how we want to do enemy implementation so I'm just kind of testing

var health = 2
var max_health = 2
var dir = 1
var damage = 1

var tile

#var enemy_pathfinding #Livi put this in game.gd
#enemy_pathfinding = Astar.new() #Livi put this in game.gd

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

func act(game):
	var my_point = game.enemy_pathfinding.get_closest_point(Vector3(tile.x, tile.y, 0))
	var player_point = game.enemy_pathfinding.get_closest_point(Vector3(game.player_tile.x, game.player_tile.y, 0))
	var path = game.enemy_pathfinding.get_point_path(my_point, player_point)
	if path:
		assert(path.size() > 1)
		var move_tile = Vector2(path[1].x, path[1].y)
		
		if move_tile == game.player_tile:
			game.damage_player(1)
		else:
			var blocked = false
			for enemy in game.enemies:
				if enemy.tile == move_tile:
					blocked = true
					break
					
			if !blocked:
				tile = move_tile

func new_turn():
	
	

	
	
#	yield(get_tree(), "idle_frame")
#	$RayCast2D.cast_to = Vector2(16 * dir, 0)
#	$RayCast2D.force_raycast_update()
#	if $RayCast2D.is_colliding():
#		if $RayCast2D.get_collider().is_in_group("Player"):
#			$RayCast2D.get_collider().get_parent().take_damage(damage)
#		else:
#			dir *= -1
#			$RayCast2D.cast_to = Vector2(16 * dir, 0)
#			$RayCast2D.force_raycast_update()
#			if $RayCast2D.is_colliding():
#				dir = 0
	tween_to(position + Vector2(get_parent().game.TILE_SIZE * dir, 0))

#func clear_path(tile):
#	var new_point = enemy_pathfinding
#	enemy_pathfinding.add_point(new_point, Vector3(tile.x, tile.y, 0))
#	var points_to_connect = []
#
#	if tile.x > 0 && map[tile.x - 1][tile.y] == Tile.Floor:
#		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x - 1, tile.y, 0)))
#	if tile.y > 0 && map[tile.x][tile.y - 1] == Tile.Floor:
#		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x, tile.y - 1, 0)))
#	if tile.x < 0 && map[tile.x + 1][tile.y] == Tile.Floor:
#		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x + 1, tile.y, 0)))
#	if tile.y < 0 && map[tile.x][tile.y + 1] == Tile.Floor:
#		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x, tile.y + 1, 0)))
#
#	for point in points_to_connect:
#		enemy_pathfinding.connect_points(point, new_point)
	



func tween_to(posn : Vector2):
	$Tween.interpolate_property(self, "position", position, posn, .1)
	$Tween.start()


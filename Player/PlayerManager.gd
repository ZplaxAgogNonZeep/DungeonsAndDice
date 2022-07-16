extends Node2D

onready var playerPath = preload("res://Player/Player.tscn")
onready var game = get_tree().root.get_node("Game")

func get_player_if_there():
	#checks if the player is currently spawned in and returns it
	# Returns Null otherwise
	if get_children() != []:
		return get_child(0)
	else:
		print("get_player is returning a null varible, please check if that's intended")
		return null

func spawn_player():
	#respawns the player
	var playerInstance = playerPath.instance()
	
	if get_child_count() > 0:
		for i in range(get_child_count()):
			print("deleting")
			get_child(i).queue_free()
	
	add_child(playerInstance)


extends Control

onready var game = get_tree().root.get_node("Game")

var sfx_volume : int
var music_volume : int

func _unhandled_input(event):
	if Input.is_action_just_pressed("Options"):
		if get_tree().paused:
			get_tree().paused = false
			visible = false
		else:
			get_tree().paused = true
			visible = true
		
func _ready():
	$SFXVolume.value = game.sfx_volume
	$MusicVolume.value = game.music_volume

func open_menu():
	pass

func _on_SFXVolume_value_changed(value):
	sfx_volume = value
	$Timer.start(.5)


func _on_MusicVolume_value_changed(value):
	music_volume = value
	$Timer.start(.5)


func _on_Timer_timeout():
	get_parent().get_parent().sfx_volume = sfx_volume
	get_parent().get_parent().music_volume = music_volume
	
	get_parent().get_parent().get_node("AudioManager").changeVolume(0, sfx_volume)
	get_parent().get_parent().get_node("AudioManager").changeVolume(1, music_volume)

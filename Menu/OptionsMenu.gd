extends Control

var sfx_volume : int
var music_volume : int


func open_menu():
	pass

func _on_SFXVolume_value_changed(value):
	sfx_volume = value
	$Timer.start(.1)


func _on_MusicVolume_value_changed(value):
	music_volume = value
	$Timer.start(.1)


func _on_Timer_timeout():
	get_parent().get_parent().sfx_volume = sfx_volume
	get_parent().get_parent().music_volume = music_volume
	
	get_parent().get_parent().get_node("AudioManager").changeVolume()

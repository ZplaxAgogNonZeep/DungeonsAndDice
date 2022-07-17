extends Node2D

var Damage_Numbers = preload("res://Damage_Numbers.tscn")

export var travel = Vector2(0, -80)
export var duration = 2
export var spread = PI/2

func show_value(posn : Vector2, value, crit=false):
	var fct = Damage_Numbers.instance()
	fct.rect_position = posn
	add_child(fct)
	fct.show_value(str(value), travel, duration, spread, crit)

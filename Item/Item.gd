extends Sprite

var tile : Vector2

var path = load("res://Item/Hammer.tscn")
var item_name := "Hammer"

export var damIncrease := 1

func equip():
	# is called when the item is first picked up
	# function MUST exist
	get_parent().get_parent().damage += damIncrease

func unequip():
	# is called when the item is put away
	get_parent().get_parent().damage -= damIncrease

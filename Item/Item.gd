extends Sprite

var tile : Vector2

var path = load("res://Item/Hammer.tscn")
var item_name := "Hammer"
var item_type := 0
# Weapon type is assigned by number
# 0 = weapon
# 1 = shield
# 2 = instant
# 3 = all

export var damIncrease := 1

func equip():
	# is called when the item is first picked up
	# function MUST exist
	get_parent().get_parent().damage += damIncrease

func unequip():
	# is called when the item is put away
	print(get_parent().name)
	get_parent().get_parent().damage -= damIncrease

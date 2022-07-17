extends Sprite

var tile : Vector2

var path = load("res://Item/Shield.tscn")
var item_name := "Shield"
var item_type := 1
# Weapon type is assigned by number
# 0 = weapon
# 1 = shield
# 2 = instant
# 3 = all

export var defIncrease := 1

func equip():
	# is called when the item is first picked up
	# function MUST exist
	get_parent().get_parent().defense += defIncrease

func unequip():
	# is called when the item is put away
	# function MUST exist
	get_parent().get_parent().defense -= defIncrease

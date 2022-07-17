extends Sprite

var tile : Vector2

var path = load("res://Item/Poison.tscn")
var item_name := "Poison"
var item_type := 2
# Weapon type is assigned by number
# 0 = weapon
# 1 = shield
# 2 = instant
# 3 = all

export var healthDecrease := 1

func equip():
	# is called when the item is first picked up
	# function MUST exist
	get_parent().get_parent().take_damage(healthDecrease)
	get_parent().get_parent().remove_item(2)


func unequip():
	# is called when the item is put away
	# function MUST exist
	pass

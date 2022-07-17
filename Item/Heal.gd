extends Sprite

var tile : Vector2

var path = load("res://Item/Heal.tscn")
var item_name := "Heal"
var item_type := 2
# Weapon type is assigned by number
# 0 = weapon
# 1 = shield
# 2 = instant
# 3 = all

export var healthIncrease := 1

func equip():
	healthIncrease = rolldice(6)
	# is called when the item is first picked up
	# function MUST exist
	if get_parent().get_parent().health < get_parent().get_parent().max_health and get_parent().get_parent().health + healthIncrease < get_parent().get_parent().max_health:
		get_parent().get_parent().health += healthIncrease
	else:
		get_parent().get_parent().health = get_parent().get_parent().max_health
	get_parent().get_parent().remove_item(2)
	

func unequip():
	# is called when the item is put away
	# function MUST exist
	pass

func rolldice(sides):
	var roll = randi() % sides + 1
	print("Potion rolled ", roll)
	return roll

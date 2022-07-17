extends Control


var previousHealth := 6


#func _ready():
#	changeDice(3)

func changeDice(newHealth : int):
	print(newHealth)
	for i in range(6):
			if i < newHealth:
				print(get_node("Dice" + str(i + 1)).name)
				get_node("Dice" + str(i + 1)).texture = load("res://art/Dice" + str(i + 1) +  ".png")
			else:
				get_node("Dice" + str(i + 1)).texture = load("res://art/black.png")


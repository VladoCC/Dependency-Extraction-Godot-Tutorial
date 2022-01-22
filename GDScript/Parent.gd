extends Node2D
class_name Mob

export (String) var mob_name

var health = 0
var gold = 0
var description = ""
var passive = true

var model

func _ready():
	print("gd")
	# you can use this dictionary as a storage for fields
	model = Database._mob_model[mob_name]
	
	# or use predefined function to assign values to vars
	health = Database.get_value(mob_name, "health")
	gold = Database.get_value(mob_name, "gold")
	description = Database.get_value(mob_name, "description")
	passive = Database.get_value(mob_name, "passive")

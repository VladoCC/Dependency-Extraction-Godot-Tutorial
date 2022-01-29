extends Node2D
class_name Parent

export (String) var key

# data previously stored in export variable
var prop: int

var model: Dictionary

func _ready():
	# you can use this dictionary as a storage for fields
	model = Database._data_model[key]
	# if you want to edit model in-game, we need to duplicate it
	# otherwise it would change_data_model and all objects created after that
	model = model.duplicate()
	
	# or use predefined function to assign values to vars
	prop = Database.get_value(key, "prop_key")

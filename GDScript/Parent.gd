extends Node2D
class_name Parent

export (String) var key

# data previously stored in export variable
var prop

var model

func _ready():
	# you can use this dictionary as a storage for fields
	model = Database._data_model[key]
	
	# or use predefined function to assign values to vars
	prop = Database.get_value(key, "prop_key")

extends Node

# our model, which stores info about different types of mobs
# name starts with underscore to show that this variable is private
var _data_model: Dictionary

func _ready():
	# open a file
	var file = File.new()
	file.open("res://example_data.json", file.READ)
	
	# parse content as json
	var content = file.get_as_text()
	_data_model = parse_json(content)

func get_value(key, field):
	if not _data_model.has(key):
		return _data_model["default"][field]
	
	return _data_model[key][field] if _data_model[key].has(field) else _data_model["default"][field]

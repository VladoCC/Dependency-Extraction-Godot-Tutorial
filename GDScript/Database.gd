extends Node

# our model, which stores info about different types of mobs
# name starts with underscore to show that this variable is private
var _mob_model: Dictionary

func _ready():
	# open a file
	var file = File.new()
	file.open("res://mob_data.json", file.READ)
	
	# parse content as json
	var content = file.get_as_text()
	_mob_model = parse_json(content)

func get_value(mob, field):
	if not _mob_model.has(mob):
		return _mob_model["default"][field]
	
	return _mob_model[mob][field] if _mob_model[mob].has(field) else _mob_model["default"][field]

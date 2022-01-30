extends Node

const path = "res://example_data.csv"

# our model, which stores info about different types of mobs
# name starts with underscore to show that this variable is private
var _data_model: Dictionary = {} setget , get_model
func get_model():
	if _data_model.empty():
		load_model()
	return _data_model

func _ready():
	# we don't want to load model twice
	# we also don't want to move this check into 
	# load_model function, because later we might want to call it
	# even if data was already load (for updating it)
	if _data_model.empty():
		load_model()

func load_model():
	# open a file
	var file = File.new()
	file.open(path, file.READ)
	
	_data_model = load_csv(file)
	
	# don't forget to close a file
	file.close()

func load_json(file: File):
	# parse content as json
	var content = file.get_as_text()
	_data_model = parse_json(content)
	
	# don't forget to close a file
	file.close()

# we want to be able to parse the same types of data from csv,
# as we're able to parse from json
# specifically, we want to have: number, boolean, null, string, array, dict
func load_csv(file: File):
	var model = {}
	
	var header = file.get_csv_line()
	while not file.eof_reached():
		var entity = {}
		
		var row = file.get_csv_line()
		for i in range(1, row.size()):
			# making sure that value in this column is presented for this class
			if row[i] != " ":
				entity[header[i]] = parse_field(row[i])
		
		model[row[0]] = entity
	
	return model

func parse_field(field: String):
	if field == "<true>":
		return true
	elif field == "<false>":
		return false
	elif field == "<null>":
		return null
	elif field == "0" or float(field) != 0:
		return float(field)
	elif is_structure(field):
		return parse_json(field)
	else:
		return field

func is_structure(text: String):
	var is_arr = text.begins_with("[") and text.ends_with("]")
	var is_dict = text.begins_with("{") and text.ends_with("}")
	return is_arr or is_dict

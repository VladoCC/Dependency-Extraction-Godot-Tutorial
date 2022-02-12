tool
extends Node

signal model_updated

const check_time = 1.0
const path = "res://example_data.json"

# our model, which stores info about different types of mobs
# name starts with underscore to show that this variable is private
var _data_model: Dictionary = {} setget , get_model
func get_model():
	if _data_model.empty():
		load_model()
	return _data_model

var timer = 0.0
var modified_at

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
	
	modified_at = file.get_modified_time(path)
	_data_model = load_json(file)
	print(_data_model)
	
	# don't forget to close a file
	file.close()

func load_json(file: File):
	# parse content as json
	var content = file.get_as_text()
	return parse_json(content)

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

func _process(delta):
	if Engine.editor_hint:
		timer += delta
		if timer > check_time:
			timer -= check_time
			check()

func check():
	var file = File.new()
	if file.get_modified_time(path) != modified_at:
		load_model()
		print("Model updated from external source")
		emit_signal("model_updated")

func edit_model(key, value):
	_data_model[key] = value
	dump()

func dump():
	var file = File.new()
	file.open(path, file.WRITE)
	
	var json = JSON.print(_data_model, "\t")
	file.store_string(json)
	file.close()
	modified_at = file.get_modified_time(path)

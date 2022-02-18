tool
extends Node2D
class_name Parent

var init = false
var export_vars: Array = ["hp"]

export (String) var key setget set_key
func set_key(new_key):
	key = new_key
	sync_to_model()

# data previously stored in export variable
export (int) var hp: int setget set_hp
func set_hp(value):
	hp = value
	update_exports()

var model: Dictionary

func update_exports():
	if init and Engine.editor_hint:
		print("Model updated by export")
		for key in export_vars:
			model[key] = get(key)
		Database.edit_model(key, model.duplicate())

func _ready():
	sync_to_model()
	if Engine.editor_hint and not Database.is_connected("model_updated", self, "sync_to_model"):
		Database.connect("model_updated", self, "sync_to_model")
	init = true

func sync_to_model():
	if not Database._data_model.has(key):
		return
	
	model = Database._data_model[key]
	# if you want to edit model in-game, we need to duplicate it
	# otherwise it would change_data_model and all objects created after that
	model = model.duplicate()
	
	for key in export_vars:
		set(key, model[key])
	
	# with this line editor GUI updates instantly, without deselecting a node
	property_list_changed_notify()

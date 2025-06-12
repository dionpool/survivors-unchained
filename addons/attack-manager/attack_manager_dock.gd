@tool

extends Window

var current_data = AttackData
var attack_files: Array = []

@onready var attack_dropdown: OptionButton = $VBoxContainer/HBoxContainer2/SelectAttackData
@onready var name_field = $VBoxContainer/NameField
@onready var selected_scene = $VBoxContainer/SelectedScene
@onready var scene_button = $VBoxContainer/SelectSceneButton
@onready var scene_dialog = $VBoxContainer/AttackSceneDialog
@onready var damage_field = $VBoxContainer/DamageField
@onready var speed_field = $VBoxContainer/SpeedField
@onready var lifetime_field = $VBoxContainer/LifetimeField
@onready var level_field = $VBoxContainer/LevelField
@onready var max_instance_field = $VBoxContainer/MaxInstanceField
@onready var save_button = $VBoxContainer/HBoxContainer/SaveButton
@onready var test_button = $VBoxContainer/HBoxContainer/TestButton

func _ready() -> void:
	_refresh_attack_list()
	
func _refresh_attack_list():
	print("Refreshing enemy list.")
	attack_dropdown.clear()
	attack_files.clear()
	
	var dir = DirAccess.open("res://attacks/")
	
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".tres"):
				attack_files.append(file)
				attack_dropdown.add_item(file)
			file = dir.get_next()
	
	attack_dropdown.item_selected.connect(_on_dropdown_item_selected)
	
func _on_dropdown_item_selected(index: int):
	if index >= 0 and index < attack_files.size():
		var path = "res://attacks/" + attack_files[index]
		_load_attack_data(path)
	else:
		push_error("Invalid index selected in dropdown.")
		
func _load_attack_data(path: String):
	current_data = load(path)
	
	if current_data:
		name_field.text = current_data.name
		selected_scene.text = current_data.attack_scene.resource_path
		speed_field.value = current_data.speed
		damage_field.value = current_data.damage
		lifetime_field.value = current_data.lifetime
		level_field.value = current_data.level
		max_instance_field.value = current_data.max_instances

func _on_load_attack_button_pressed() -> void:
	print("Loading attack data...")
	
	var index = attack_dropdown.get_selected()
	
	if index == -1:
		push_error("No attack selected.")
		return
	
	var filename = attack_dropdown.get_item_text(index)
	var full_path = "res://attacks/" + filename
	
	_load_attack_data(full_path)

func _on_new_attack_button_pressed() -> void:
	print("Creating new attack data...")
	
	current_data = AttackData.new()
	name_field.text = ""
	speed_field.value = 50.0
	damage_field.value = 0
	lifetime_field.value = 0.0
	level_field.value = 1
	max_instance_field.value = 1

func _on_select_scene_button_pressed() -> void:
	scene_dialog.popup_centered()

func _on_attack_scene_dialog_file_selected(path: String) -> void:
	print("Selected scene: ", path)
	
	selected_scene.text = path
	
	if current_data:
		var scene = load(path)
		
		if scene is PackedScene:
			current_data.attack_scene = scene
			print("Attack scene assigned.")

func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		hide()

func _on_save_button_pressed() -> void:
	print("Saving attack data...")
	
	if current_data:
		current_data.name = name_field.text
		current_data.speed = float(speed_field.value)
		current_data.damage = int(damage_field.value)
		current_data.lifetime = float(lifetime_field.value)
		current_data.level = int(level_field.value)
		current_data.max_instances = int(max_instance_field.value)
		
		var clean_name = current_data.name.to_lower().replace(" ", "_")
		var filename = clean_name + "_data.tres"
		var suggested_path = "res://attacks/" + filename
		
		if not current_data.attack_scene:
			push_error("No scene assigned to this attack.")
			return
		
		if current_data.resource_path == "":
			var result = ResourceSaver.save(current_data, suggested_path)
			print("Saved to: ", suggested_path)
		else:
			ResourceSaver.save(current_data, current_data.resource_path)
			filename = current_data.resource_path.get_file()
			
		var name_exists := false
		for i in attack_dropdown.item_count:
			if attack_dropdown.get_item_text(i) == filename:
				name_exists = true
				break

		if not name_exists:
			attack_dropdown.add_item(filename)
			
	else:
		push_error("No `current_data` to save.")

@tool

extends Window

var current_data: EnemyData
var enemy_files: Array = []

@onready var enemy_dropdown: OptionButton = $VBoxContainer/HBoxContainer/SelectEnemyData
@onready var name_field = $VBoxContainer/NameField
@onready var health_field = $VBoxContainer/HealthField
@onready var damage_field = $VBoxContainer/DamageField
@onready var speed_field = $VBoxContainer/SpeedField
@onready var experience_field = $VBoxContainer/ExperienceField
@onready var description_field = $VBoxContainer/DescriptionField
@onready var scene_preview = $VBoxContainer/ScenePreview
@onready var scene_button = $VBoxContainer/SelectEnemyScene
@onready var selected_scene = $VBoxContainer/SelectedScene
@onready var scene_dialog = $VBoxContainer/EnemySceneDialog
@onready var save_button = $VBoxContainer/SaveButton

func _ready() -> void:
	_refresh_enemy_list()

func _refresh_enemy_list():
	print("Refreshing enemy list.")
	enemy_dropdown.clear()
	enemy_files.clear()
	
	var dir = DirAccess.open("res://characters/enemies/")
	
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".tres"):
				enemy_files.append(file)
				enemy_dropdown.add_item(file)
			file = dir.get_next()
	
	enemy_dropdown.item_selected.connect(_on_dropdown_item_selected)

func _on_dropdown_item_selected(index: int) -> void:
	if index >= 0 and index < enemy_files.size():
		var path = "res://characters/enemies/" + enemy_files[index]
		_load_enemy_data(path)
	else:
		push_error("Invalid index selected in dropdown.")

func _load_enemy_data(path: String):
	current_data = load(path)
	
	if current_data:
		name_field.text = current_data.name
		description_field.text = current_data.description
		health_field.value = current_data.health
		speed_field.value = current_data.speed
		damage_field.value = current_data.damage
		experience_field.value = current_data.experience

func _on_load_button_pressed() -> void:
	print("Loading enemy data...")
	
	var index = enemy_dropdown.get_selected()
	
	if index == -1:
		push_error("No enemy selected.")
		return
	
	var filename = enemy_dropdown.get_item_text(index)
	var full_path = "res://characters/enemies/" + filename
	
	_load_enemy_data(full_path)

func _on_save_button_pressed() -> void:
	print("Saving enemy data...")
	
	if current_data:
		current_data.name = name_field.text
		current_data.description = description_field.text
		current_data.health = int(health_field.value)
		current_data.speed = float(speed_field.value)
		current_data.damage = int(damage_field.value)
		current_data.experience = int(experience_field.value)
		
		var clean_name = current_data.name.to_lower().replace(" ", "_")
		var filename = clean_name + "_data.tres"
		var suggested_path = "res://characters/enemies/" + filename
		
		if not current_data.enemy_scene:
			push_error("No scene assigned to this enemy.")
			return
		
		if current_data.resource_path == "":
			var result = ResourceSaver.save(current_data, suggested_path)
			print("Saved to: ", suggested_path)
		else:
			ResourceSaver.save(current_data, current_data.resource_path)
			filename = current_data.resource_path.get_file()
			
		var name_exists := false
		for i in enemy_dropdown.item_count:
			if enemy_dropdown.get_item_text(i) == filename:
				name_exists = true
				break

		if not name_exists:
			enemy_dropdown.add_item(filename)
			
	else:
		push_error("No `current_data` to save")

func _on_new_enemy_button_pressed() -> void:
	print("Creating new enenmy data...")
	
	current_data = EnemyData.new()
	name_field.text = ""
	description_field.text = ""
	health_field.value = 10
	speed_field.value = 50
	damage_field.value = 2
	experience_field.value = 5
	scene_preview.texture = null

func _on_select_enemy_scene_pressed() -> void:
	scene_dialog.popup_centered()

func _on_enemy_scene_dialog_file_selected(path: String) -> void:
	print("Selected scene: ", path)
	
	selected_scene.text = path.get_file()
	
	if current_data:
		var scene = load(path)
		
		if scene is PackedScene:
			current_data.enemy_scene = scene
			print("Enemy scene assigned.")
			
			var instance = scene.instantiate()
			
			if instance:
				var preview_texture: Texture2D = null
				
				if instance.has_node("Sprite2D"):
					var sprite = instance.get_node("Sprite2D") as Sprite2D
					
					preview_texture = sprite.texture
				elif instance.has_node("AnimatedSprite2D"):
					var anim = instance.get_node("AnimatedSprite2D") as AnimatedSprite2D
					
					if anim.sprite_frames and anim.sprite_frames.get_frame_count("walk") > 0:
						preview_texture = anim.sprite_frames.get_frame_texture("walk", 0)
				
				scene_preview.texture = preview_texture
				
				if not preview_texture:
					push_warning("Could not preview enemy - no Sprite2D or valid AnimatedSprite2D found.")

func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		hide()

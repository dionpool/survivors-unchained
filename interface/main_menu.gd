extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/forest/forest.tscn")

func _on_options_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()

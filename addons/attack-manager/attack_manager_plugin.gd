@tool

extends EditorPlugin

var manager_window: Window

func _enter_tree() -> void:
	manager_window = preload("res://addons/attack-manager/attack_manager_dock.tscn").instantiate()
	manager_window.title = "Attack Manager"
	manager_window.hide()
	
	get_tree().root.add_child(manager_window)
	
	add_tool_menu_item("Open Attack Manager", _on_open_attack_manager)

func _on_open_attack_manager():
	if manager_window:
		manager_window.popup_centered_ratio(0.7)

func _exit_tree() -> void:
	remove_tool_menu_item("Open Attack Manager")
	if manager_window:
		manager_window.queue_free()
		manager_window = null

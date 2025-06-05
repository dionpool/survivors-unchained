@tool

extends EditorPlugin

var manager_window: Window

func _enter_tree() -> void:
	manager_window = preload("res://addons/enemy-manager/enemy_manager_dock.tscn").instantiate()
	manager_window.title = "Enemy Manager"
	manager_window.hide()
	
	get_tree().root.add_child(manager_window)
	
	add_tool_menu_item("Open Enemy Manager", _on_open_enemy_manager)
	
func _on_open_enemy_manager():
	if manager_window:
		manager_window.popup_centered_ratio(0.7)
	
func _exit_tree() -> void:
	remove_tool_menu_item("Open Enemy Manager")
	if manager_window:
		manager_window.queue_free()
		manager_window = null

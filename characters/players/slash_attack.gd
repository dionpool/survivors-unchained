extends Node

@export var slash_data: AttackData
@export var interval := 0.3
@export var offset := Vector2(32, 0)

var timer := 0.0

func _process(delta: float) -> void:
	timer += delta
	if timer >= interval:
		timer = 0.0
		spawn_slash()

func spawn_slash():
	var count = get_tree().get_nodes_in_group("player_attack").filter(
		func(n): return n is Area2D and n.data == slash_data
	).size()
	
	if count >= slash_data.max_instances:
		return
	
	if get_tree().get_nodes_in_group("enemies").is_empty():
		return
	
	if slash_data and slash_data.attack_scene:
		var slash = slash_data.attack_scene.instantiate()
		
		var player = get_parent()
		slash.global_position = player.global_position + offset
		slash.source = player
		
		slash.call_deferred("setup", slash_data)
		get_tree().current_scene.add_child(slash)
	else:
		print("No slash data or attack scene found.")

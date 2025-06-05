extends Node2D

@export var player: Node2D
@export var enemy_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var spawn_distance: float = 600.0

var timer := 0.0

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		spawn_enemy()
		timer = spawn_interval

func spawn_enemy():
	if not player or not enemy_scene:
		return
	
	var direction = Vector2.RIGHT.rotated(randf() * TAU)
	var spawn_position = player.global_position + direction * spawn_distance
	var enemy = enemy_scene.instantiate()
	
	enemy.data = preload("res://characters/enemies/skeleton_data.tres")
	enemy.player = player
	enemy.global_position = spawn_position
	
	get_tree().current_scene.add_child(enemy)

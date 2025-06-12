extends Node2D

@export var player: Node2D
@export var spawn_interval: float = 2.0
@export var spawn_distance: float = 600.0

var timer := 0.0
var current_wave_enemies: Array = []

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0 and current_wave_enemies.size() > 0:
		var enemy_info = current_wave_enemies.pop_front()
		spawn_enemy(enemy_info.scene, enemy_info.data_path)
		timer = spawn_interval

func spawn_enemy(scene: PackedScene, data_path: String):
	if not player or not scene:
		return
		
	var direction = Vector2.RIGHT.rotated(randf() * TAU)
	var spawn_position = player.global_position + direction * spawn_distance
	var enemy = scene.instantiate()
	
	enemy.global_position = spawn_position
	enemy.player = player
	if enemy is EnemyBase:
		enemy.data = load(data_path)
	
	get_tree().current_scene.add_child(enemy)
	
func set_wave_enemies(enemies: Array):
	current_wave_enemies = enemies.duplicate()

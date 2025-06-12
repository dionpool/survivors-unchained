extends Node

@export var spawner: NodePath
@export var wave_delay: float = 5.0

var wave_index := 0
var time_until_next_wave := 0.0
var is_wave_active := false

var waves = [
	[
		{
			"scene": preload("res://characters/enemies/skeleton.tscn"),
			"data_path": "res://characters/enemies/skeleton_data.tres",
			"count": 100
		}
	]
]

func _ready():
	time_until_next_wave = wave_delay

func _process(delta: float) -> void:
	if is_wave_active:
		return
	
	time_until_next_wave -= delta
	if time_until_next_wave <= 0:
		start_wave(wave_index)
		wave_index += 1
		is_wave_active = true

func start_wave(index: int):
	if index >= waves.size():
		print("All waves completed!")
		return
		
	var wave = waves[index]
	var spawner_node = get_node(spawner)
	var spawn_list: Array = []
	
	for enemy in wave:
		for i in enemy.count:
			spawn_list.append({
				"scene": enemy.scene,
				"data_path": enemy.data_path
			})
	
	spawner_node.set_wave_enemies(spawn_list)
	is_wave_active = false
	time_until_next_wave = wave_delay

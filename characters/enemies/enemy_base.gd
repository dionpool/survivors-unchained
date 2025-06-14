extends CharacterBody2D

class_name EnemyBase

@export var data: EnemyData

@onready var _sprite = $Sprite2D

var player: Node2D
var speed: float
var health: int
var damage: int
var experience: int

func _ready() -> void:
	add_to_group("enemies")
	if data:
		speed = data.speed
		health = data.health
		damage = data.damage
		experience = data.experience
			
func setup(enemy_data: EnemyData, target: Node2D) -> void:
	data = enemy_data
	player = target

	speed = data.speed
	health = data.health
	damage = data.damage
	experience = data.experience

	if data.sprite_texture:
		_sprite.texture = data.sprite_texture

func _physics_process(_delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		
		velocity = direction * speed
		move_and_slide()
		
		_sprite.flip_h = velocity.x > 0

func take_damage(amount: int):
	health -= amount
	print("Enemy took ", amount, " damage. Remaing health: ", health)
	if health <= 0:
		print("Enemy died.")
		die()

func die():
	queue_free()

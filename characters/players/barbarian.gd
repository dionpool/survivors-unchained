extends CharacterBody2D

@export var speed: float = 50.0
@export var max_health := 100
@export var damage: int = 2
@export var experience: int = 5
@export var level: int = 1

var health := max_health
var can_take_damage := true

@onready var _animated_sprite = $AnimatedSprite2D
@onready var health_bar = $AnimatedSprite2D/HealthBar

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed

func _physics_process(_delta):
	# Movement
	if Input.get_vector("Left", "Right", "Up", "Down"):
		_animated_sprite.play("run")
		get_input()	
		move_and_slide()
	else:
		_animated_sprite.stop()
		
	# Flip player
	if Input.is_action_pressed("Left"):
		_animated_sprite.flip_h = true
	elif Input.is_action_pressed("Right"):
		_animated_sprite.flip_h = false

func _on_hurt_box_area_entered(area: Area2D) -> void:
	print("Enemy entered my HurtBox:", area.name)
	_apply_damage(10)
		
func _apply_damage(amount: int):
	if not can_take_damage:
		return
	
	health -= amount
	health = clamp(health, 0, max_health)
	health_bar.value = health
	
	if health <= 0:
		print("Player died.")
		
	can_take_damage = false
	await get_tree().create_timer(0.5).timeout
	can_take_damage = true

extends Area2D

var data: AttackData
var damage: int
var lifetime: float = 0.3
var velocity: Vector2 = Vector2.ZERO
var source: Node = null

func setup(attack_data: AttackData):
	data = attack_data
	damage = data.damage
	lifetime = data.lifetime
	
	var nearest = _get_nearest_enemy()
	
	if nearest:
		var direction = (nearest.global_position - global_position).normalized()
		
		velocity = direction * data.speed
		rotation = direction.angle()
		
		print(velocity)
	else:
		velocity = Vector2.ZERO
	
	await get_tree().create_timer(data.lifetime).timeout
	queue_free()

func _ready() -> void:
	add_to_group("player_attack")
	$CollisionShape2D.disabled = false

func _process(delta: float) -> void:
	position += velocity * delta

func _on_area_entered(area: Area2D) -> void:
	var root = area.get_owner()
	
	if root == source:
		return
	
	if root and root.is_in_group("characters"):
		return
	
	if root and root.is_in_group("enemies"):
		if root.has_method("take_damage"):
			root.take_damage(damage)

func _get_nearest_enemy() -> Node2D:
	var closest = null
	var closest_distance = INF
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not enemy is Node2D:
			continue
		
		var distance = global_position.distance_to(enemy.global_position)
		
		if distance < closest_distance:
			closest = enemy
			closest_distance = distance
		
	return closest

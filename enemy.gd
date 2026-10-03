extends CharacterBody2D

@export var movement_speed: float = 40.0
@export var knockback_strength: float = 200
@export var knockback_friction: float = 500

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var movement_delta: float
var knockback_velocity := Vector2.ZERO
var is_being_knocked_back := false

var rng = RandomNumberGenerator.new()

@export var health: int = 3


func _ready() -> void:
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	rng.randomize()
	var randomSpeed = rng.randf() * 20 - 10
	movement_speed = max(movement_speed + randomSpeed, 1)

func set_movement_target(movement_target: Vector2) -> void:
	navigation_agent.set_target_position(movement_target)


func damage(amount: int, player_pos: Vector2) -> void:
	health -= amount

	# Direction from the attacker to this enemy.
	var knockback_direction := player_pos.direction_to(global_position)

	rng.randomize()
	var randomKnock = rng.randf() * 50 - 25
	knockback_velocity = knockback_direction * max(knockback_strength + randomKnock, 0)
	is_being_knocked_back = true
	
	
	
	var tween = create_tween()
	if health <= 0:
		$Timer.start()
		tween.tween_property(self, "scale", Vector2(0,0), 0.3)
	else:
		tween.tween_property(self, "modulate", Color(0.5, 0.5, 0.5, 1.0), 0.05)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1.0), 0.35)
	



func _physics_process(delta: float) -> void:
	# Knockback temporarily takes control of movement.
	if is_being_knocked_back:
		velocity = knockback_velocity
		move_and_slide()

		# Gradually reduce knockback speed.
		knockback_velocity = knockback_velocity.move_toward(
			Vector2.ZERO,
			knockback_friction * delta
		)

		if knockback_velocity.length() < 5.0:
			knockback_velocity = Vector2.ZERO
			is_being_knocked_back = false
		$Animation.play("idle")

		return
	if health <= 0:
		return

	# Wait until the navigation map is ready.
	if NavigationServer2D.map_get_iteration_id(
		navigation_agent.get_navigation_map()
	) == 0:
		return

	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	movement_delta = movement_speed * delta
	$Animation.play("walk")

	var next_path_position := navigation_agent.get_next_path_position()
	var desired_velocity := global_position.direction_to(next_path_position) * movement_speed

	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = desired_velocity
	else:
		_on_velocity_computed(desired_velocity)

	look_at(navigation_agent.target_position)
	
func _process(delta: float) -> void:
	if health <= 0:
		return
	if $ShapeCast2D.is_colliding():
		var collision_count = $ShapeCast2D.get_collision_count()
		for i in range(collision_count):
			var collider = $ShapeCast2D.get_collider(i)
			if collider != null:
				if collider.is_in_group("Player"):
					collider.take_damage()


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
	
func _on_timer_timeout() -> void:
	queue_free()

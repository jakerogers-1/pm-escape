extends RigidBody2D

var thrown = false
var disappearing = false
var moving = false

func throw(direction : Vector2, force : float):
	if !thrown:
		print("Before: ", linear_velocity)
		apply_central_impulse(direction * force)
		print("After: ", linear_velocity.length())
		thrown = true
	
func _physics_process(delta: float) -> void:
	if linear_velocity.length() > 5:
		moving = true
		
	#print(linear_velocity.length())
	if thrown && !disappearing && moving:
		if linear_velocity.length() < 10:
			disappearing = true
			var tween = create_tween()
			$CPUParticles2D.emitting = true
			tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 1)
			$Timer.start()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy") && linear_velocity.length() > 30:
		body.damage(5, position)
		disappearing = true
		var tween = create_tween()
		$CPUParticles2D.emitting = true
		tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 1)
		$Timer.start()


func _on_timer_timeout() -> void:
	queue_free()

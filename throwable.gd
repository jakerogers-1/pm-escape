extends RigidBody2D

func throw(direction : Vector2, force : float):
	apply_central_impulse(direction * force)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy") && linear_velocity.length() > 30:
		body.damage(5, position)

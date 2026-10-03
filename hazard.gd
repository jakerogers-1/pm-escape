extends Node2D

func _process(delta: float) -> void:
	if $ShapeCast2D.is_colliding():
		var collision_count = $ShapeCast2D.get_collision_count()
		for i in range(collision_count):
			var collider = $ShapeCast2D.get_collider(i)
			if collider != null:
				if collider.is_in_group("Player"):
					collider.take_damage()

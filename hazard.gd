extends Node2D

@export var paper : Texture2D
@export var water : Texture2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var r = rng.randi_range(0,1)
	if r == 0:
		$Sprite2D.texture = paper
		$Sprite2D.scale = Vector2(0.5,0.5)
	else:
		$Sprite2D.texture = water

func _process(delta: float) -> void:
	if $ShapeCast2D.is_colliding():
		var collision_count = $ShapeCast2D.get_collision_count()
		for i in range(collision_count):
			var collider = $ShapeCast2D.get_collider(i)
			if collider != null:
				if collider.is_in_group("Player"):
					collider.take_damage()

extends Node2D

# How fast the player moves in meters per second.
@export var speed = 14

var screen_size #Size of the game window
var target_velocity = Vector3.ZERO

func _ready() -> void:
	screen_size = get_viewport_rect().size
	
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("stop")
		
	#delta = frame length
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	look_at(get_global_mouse_position())

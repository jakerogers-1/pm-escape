extends CharacterBody2D

# How fast the player moves in meters per second.
@export var speed = 14

var screen_size #Size of the game window

var attacking = false;
var rightHand = true;

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
	
	if Input.is_action_just_pressed("punch"):
		if !attacking:
			attack()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if !attacking:
			$AnimatedSprite2D.play("walk")
	else:
		if !attacking:
			$AnimatedSprite2D.play("stop")
		
	#delta = frame length
	move_and_collide(velocity * delta)
	#position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	look_at(get_global_mouse_position())

func attack() -> void:
	if rightHand:
		$AnimatedSprite2D.play("punch1")
		rightHand = false
	else: 
		$AnimatedSprite2D.play("punch2")
		rightHand = true
	attacking = true

func _on_animated_sprite_2d_animation_finished() -> void:
	# Trigger the next animation or action
	if Input.is_action_pressed("punch"):
		attack()
	else:
		attacking = false

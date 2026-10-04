extends CharacterBody2D

# How fast the player moves in meters per second.
@export var speed = 14
@export var throwForce = 100
#@export var health : int = 5

var attacking = false
var rightHand = true
var dead = false

var objectHeld
var objectOGParent

func _ready() -> void:
	dead = false
	
func _process(delta: float) -> void:
	if dead:
		return
	velocity = Vector2.ZERO # The player's movement vector.
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
	
	check_pickup()
		

	#delta = frame length
	move_and_slide()

	look_at(get_global_mouse_position())

func attack() -> void:
	if dead:
		return
	if rightHand:
		$AnimatedSprite2D.play("punch1")
		rightHand = false
	else: 
		$AnimatedSprite2D.play("punch2")
		rightHand = true
	if $ShapeCast2D.is_colliding():
		var collision_count = $ShapeCast2D.get_collision_count()
		for i in range(collision_count):
			var collider = $ShapeCast2D.get_collider(i)
			if collider.is_in_group("Enemy"):
				collider.damage(1, position)
	attacking = true
	
func check_pickup():
	if Input.is_action_just_pressed("pickup") && objectHeld == null:
		if $ShapeCast2D.is_colliding():
			var collision_count = $ShapeCast2D.get_collision_count()
			for i in range(collision_count):
				var collider = $ShapeCast2D.get_collider(i)
				if collider.is_in_group("Throwable") && objectHeld == null:
					objectOGParent = collider.get_parent()
					if objectOGParent != null:
						objectOGParent.remove_child(collider)
					self.add_child(collider)
					collider.position = Vector2.ZERO
					objectHeld = collider
	if Input.is_action_just_released("pickup"):
		if objectHeld != null:
			remove_child(objectHeld)
			objectOGParent.add_child(objectHeld)
			objectHeld.global_position = global_position
			objectHeld.throw(global_position.direction_to(get_global_mouse_position()), throwForce)
			objectHeld = null
	
func take_damage():
	if !dead:
		$AnimatedSprite2D.play("death")
		dead = true

func _on_animated_sprite_2d_animation_finished() -> void:
	# Trigger the next animation or action
	if Input.is_action_pressed("punch"):
		attack()
	else:
		attacking = false

extends Node2D

@export var enemyChance = 0.2
@export var throwableChance = 0.1
@export var hazardChance = 0.1

@export var enemy_scene = preload("res://levels/room_a.tscn") 
@export var throwable_scene = preload("res://levels/room_b.tscn")
@export var hazard_scene = preload("res://levels/room_b.tscn")

var rng = RandomNumberGenerator.new()

func spawn():
	rng.randomize()
	if rng.randf() < enemyChance:
		var enemy = enemy_scene.instantiate()
		add_child(enemy)
		return
	elif rng.randf() < enemyChance + throwableChance:
		var throwable = throwable_scene.instantiate()
		add_child(throwable)
		return
	elif rng.randf() < enemyChance + throwableChance + hazardChance:
		var hazard = hazard_scene.instantiate()
		add_child(hazard)
		return
	
	

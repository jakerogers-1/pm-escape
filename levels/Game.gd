extends Node2D

@export var enemies : Array[CharacterBody2D] = []

func updateEnemies(enems) -> void:
	for enemy in enems:
		if enemy != null:
			enemy.set_movement_target($Player.position)

func _process(delta: float) -> void:
	updateEnemies(enemies)

extends Node2D

var level_0_scene = preload("res://level_0_handler.tscn")
var level_1_scene = preload("res://level_1_handler.tscn")
var level_2_scene = preload("res://level_2_handler.tscn")
var victory_scene = preload("res://victory.tscn")

var level_0
var level_1
var level_2
var victory

func _ready() -> void:
	level_0 = level_0_scene.instantiate()
	level_0.level0_finished.connect(_on_level_0_finished)
	add_child(level_0)
	
func _on_level_0_finished() -> void:
	# Prevent repeated signals from creating multiple levels.
	if is_instance_valid(level_1):
		return

	print("Level 0 finished; loading level 1.")

	level_0.queue_free()
	level_0 = null

	level_1 = level_1_scene.instantiate()
	level_1.level1_finished.connect(_on_level_1_finished)
	add_child(level_1)

func _on_level_1_finished() -> void:
	print("Level 1 finished!")
	# Load level 2 or display a victory screen here.

	level_1.queue_free()
	level_1 = null

	level_2 = level_2_scene.instantiate()
	level_2.level2_finished.connect(_on_level_2_finished)
	add_child(level_2)

func _on_level_2_finished() -> void:
	
	level_2.queue_free()
	level_2 = null
	
	victory = victory_scene.instantiate()
	add_child(victory)	
	print("HOORAY YOU WON")

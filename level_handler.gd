extends Node2D

var level_0_scene = preload("res://level_0_handler.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var level_0 = level_0_scene.instantiate()
	
	get_tree().change_scene_to_file(level_0)
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

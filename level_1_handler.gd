extends Node2D

signal level1_finished()
var level_finished: bool = false

var room_a_scene = preload("res://levels/level1/level1a.tscn") 
var room_b_scene = preload("res://levels/level1/level1b.tscn")
var room_c_scene = preload("res://levels/level1/level1c.tscn")

var player_scene = preload("res://Player/Player.tscn")
var room_names = ['a', 'b', 'c']
var num_rooms = 2
var room_data = []

var enemies : Array[Node] = [] 

var player: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("LEVEL 1 LOADED")
	var room_group = Node2D.new()
	room_group.name = "GeneratedRoomsLevel1"

	# Instantiate the rooms.
	# Assumes room_names is nonempty and contains only "a" and "b".
	for count in range(num_rooms):
		var room_let = room_names[
			randi_range(0, room_names.size() - 1)
		]		
		print(room_let)
		if room_let == "a":
			room_data.append(room_a_scene.instantiate())
		elif room_let == "b":
			room_data.append(room_b_scene.instantiate())
		elif room_let == "c":
			room_data.append(room_c_scene.instantiate())



	# Put every room inside the container.
	for room in room_data:
		room_group.add_child(room)

	add_child(room_group)	
	
	# Attach each room to the previous one.
# Attach each room to the previous one.
	for index in range(1, room_data.size()):
		var previous_doors = get_doors(room_data[index - 1])
		var current_doors = get_doors(room_data[index])

		var previous_door = previous_doors["upper"]
		var current_door = current_doors["lower"]

		if previous_door == null or current_door == null:
			push_error("Missing upper or lower door collision shape.")
			return

		room_data[index].global_position += (
			previous_door.global_position
			- current_door.global_position
			- Vector2(0, 32.0)
		)
			
	var spawners = get_tree().get_nodes_in_group("Spawner")
	for spawner in spawners:
		spawner.spawn()

	enemies = get_tree().get_nodes_in_group("EnemyAgent")

	# Spawn player
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = get_doors(room_data[0])["lower"].global_position

# Called every frame. 'delta' is the elapsed time swince the previous frame.
func _process(_delta: float) -> void:
	if level_finished or not is_instance_valid(player):
		return

	if room_data.is_empty():
		return

	var final_door = get_doors(room_data[-1])["upper"]

	if final_door == null:
		return

	if player.global_position.distance_to(final_door.global_position) <= 17.0:
		level_finished = true
		print("LEVEL FINISHED")
		level1_finished.emit()
func get_doors(room: Node) -> Dictionary:
	var doors_dict = { "upper" : null, "lower" : null }

	for child in room.find_children("Door*", "StaticBody2D", true, false):

		if String(child.name).begins_with("DoorUpper"):
			doors_dict["upper"] = child.get_child(0)
		elif String(child.name).begins_with("DoorLower"):
			doors_dict["lower"] = child.get_child(0)


	return doors_dict

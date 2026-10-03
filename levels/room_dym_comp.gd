extends Node2D

enum DoorType { LEFT, RIGHT, UPPER, LOWER }

var room_a_scene = preload("res://levels/room_dym_a.tscn") 
var room_b_scene = preload("res://levels/room_dym_b.tscn")
var room_c_scene = preload("res://levels/room_dym_c.tscn")
var room_d_scene = preload("res://levels/room_dym_d.tscn")
var room_e_scene = preload("res://levels/room_dym_e.tscn")

var player_scene = preload("res://Player/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Add randomization code for initial room
	# ...
	
	var room_names = ['a', 'b', 'c', 'd', 'e']
	var room_nums = 4

	var room_data: Array[Node2D] = []

	var room_group = Node2D.new()
	room_group.name = "GeneratedRooms"

	# Instantiate the rooms.
	# Assumes room_names is nonempty and contains only "a" and "b".
	for count in range(room_nums):
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
		elif room_let == "d":
			room_data.append(room_d_scene.instantiate())
		elif room_let == "e":
			room_data.append(room_e_scene.instantiate())

	# Put every room inside the container.
	for room in room_data:
		room_group.add_child(room)

	add_child(room_group)	
	
	# Attach each room to the previous one.
	for index in range(1, room_data.size()):
		var previous_door = get_doors(room_data[index - 1])[1]
		var current_door = get_doors(room_data[index])[0]

		room_data[index].global_position += (
			previous_door.global_position
			- current_door.global_position
			+ Vector2(0, 64.0)
		)
		
	# Spawn player
	var player = player_scene.instantiate()
	add_child(player)
	player.global_position = get_doors(room_data[0])[0].global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_doors(room: Node) -> Array:
	var doors = [];
	for child in room.find_children("Door*", "Marker2D", true, false):
		var door = []
		
		if 'Upper' in child.name:
			door[0] = DoorType.UPPER
		elif 'Lower' in child.name:
			door[0] = DoorType.LOWER
		elif 'Left' in child.name:
			door[0] = DoorType.LEFT
		elif 'Right' in child.name:
			door[0] = DoorType.RIGHT
		
		door[1] = child.find_child("CollisionShape2D", true, false)
			
	return doors

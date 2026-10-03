extends Node2D

var room_scenes = [
	preload("res://levels/room_dym_a.tscn"),
	preload("res://levels/room_dym_b.tscn"),
	preload("res://levels/room_dym_c.tscn"),
	preload("res://levels/room_dym_d.tscn"),
	preload("res://levels/room_dym_e.tscn")
]

var player_scene = preload("res://Player/Player.tscn")

@export var room_nums: int = 4
@export var door_gap: float = 64.0


func _ready() -> void:
	if room_nums <= 0:
		return

	# Only use templates containing both an upper and lower door.
	var available_scenes: Array[PackedScene] = []

	for scene in room_scenes:
		var sample = scene.instantiate()

		if not get_doors(sample).is_empty():
			available_scenes.append(scene)
		else:
			push_warning("Skipping room without both vertical doors: %s"
				% scene.resource_path)

		sample.free()

	if available_scenes.is_empty():
		push_error("No rooms contain both upper and lower door markers.")
		return

	var room_group = Node2D.new()
	room_group.name = "GeneratedRooms"
	add_child(room_group)

	var room_data: Array[Node2D] = []

	# Instantiate random rooms. Templates may repeat.
	for count in range(room_nums):
		var scene: PackedScene = available_scenes.pick_random()
		var room: Node2D = scene.instantiate()

		room_group.add_child(room)
		room_data.append(room)

	room_data[0].position = Vector2.ZERO

	# Connect previous lower door to current upper door.
	for index in range(1, room_data.size()):
		var previous_door: Marker2D = get_doors(
			room_data[index - 1]
		)[1]

		var current_door: Marker2D = get_doors(
			room_data[index]
		)[0]

		room_data[index].global_position += (
			previous_door.global_position
			- current_door.global_position
			+ Vector2(0, door_gap)
		)

	# Spawn at the first room's upper marker.
	var spawn_marker: Marker2D = get_doors(room_data[0])[0]
	var player = player_scene.instantiate()

	add_child(player)
	player.global_position = spawn_marker.global_position


func get_doors(room: Node) -> Array[Marker2D]:
	var upper: Marker2D = null
	var lower: Marker2D = null

	for child in room.find_children("Door*", "Marker2D", true, false):
		var marker: Marker2D = child as Marker2D
		var marker_name = String(marker.name)

		if marker_name.begins_with("DoorUpper") and upper == null:
			upper = marker
		elif marker_name.begins_with("DoorLower") and lower == null:
			lower = marker

	if upper == null or lower == null:
		return []

	return [upper, lower]

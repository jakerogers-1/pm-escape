extends Node2D

var room_a_scene = preload("res://levels/room_a.tscn") 
var room_b_scene = preload("res://levels/room_b.tscn")

var player_scene = preload("res://Player/Player.tscn")

var enemies : Array[Node] = [] 

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Add randomization code for initial room
	# ...
	
	var room_names = ['a', 'b']
	var room_nums = 10

	var room_data = []

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
			
	# Spawn player
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = get_doors(room_data[0])["lower"].global_position

	var spawners = get_tree().get_nodes_in_group("Spawner")
	for spawner in spawners:
		spawner.spawn()

	enemies = get_tree().get_nodes_in_group("EnemyAgent")

	
	# Setup navigation mesh - didn't seem to be working
	#var new_navigation_mesh = NavigationPolygon.new()
	#var maxY = room_data[room_data.size() - 1].global_position.y + 100
	#var bounding_outline = PackedVector2Array([Vector2(0, 0), Vector2(0, maxY), Vector2(50, maxY), Vector2(50, 0)])
	#new_navigation_mesh.add_outline(bounding_outline)
	#var mesh_source = NavigationMeshSourceGeometryData2D.new()
	#mesh_source.add_traversable_outline(bounding_outline)
	#NavigationServer2D.bake_from_source_geometry_data_async(new_navigation_mesh, mesh_source, Call_Bake)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateEnemies(enemies)
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
func updateEnemies(enems) -> void:
	for enemy in enems:
		if enemy != null:
			enemy.set_movement_target(player.global_position)
	
func get_doors(room: Node) -> Dictionary:
	var doors_dict = { "upper" : null, "lower" : null }

	for child in room.find_children("Door*", "StaticBody2D", true, false):

		if String(child.name).begins_with("DoorUpper"):
			doors_dict["upper"] = child.get_child(0)
		elif String(child.name).begins_with("DoorLower"):
			doors_dict["lower"] = child.get_child(0)


	return doors_dict
	
#func Call_Bake() -> void:
	#bake_navigation_polygon(true)

extends Node2D

@onready var image: Sprite2D = $Sprite2D

@onready var camera: Camera2D = $Camera2D
const NEXT_SCENE := "res://level_handler.tscn"

func _ready() -> void:
	# Make sure the camera is active
	camera.enabled = true

	# Place the image at the camera's center
	image.global_position = camera.global_position

	# Get the image's original pixel size
	var image_size: Vector2 = image.texture.get_size()

	# Get the visible camera area
	var viewport_size: Vector2 = get_viewport_rect().size
	var camera_zoom: Vector2 = camera.zoom

	# Convert viewport size into world-space size
	var visible_size := viewport_size / camera_zoom

	# Calculate the scale needed to cover the screen.
	# max() ensures there are no empty borders.
	var fill_scale = max(
		visible_size.x / image_size.x,
		visible_size.y / image_size.y
	)

	# Start more zoomed in
	image.scale = Vector2.ONE * fill_scale * 1.5

	# Zoom out until the image fills the screen
	var tween := create_tween()

	tween.tween_property(
		image,
		"scale",
		Vector2.ONE * fill_scale,
		4.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Change scene after the zoom finishes
	await tween.finished
	get_tree().change_scene_to_file(NEXT_SCENE)

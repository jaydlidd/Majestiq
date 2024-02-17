extends Button

# Piece variables
@export var draggable_object:PackedScene
@export var button_icon:Texture2D
var piece:Node
var is_dragging:bool = false
var collided_object_id

# Camera / raycasting variables
var RAYCAST_LENGTH = 1000
var camera:Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = button_icon									# Set the button icon
	piece = draggable_object.instantiate()				# Set the object to be created one button select
	add_child(piece)									# Add the piece to the scene
	piece.visible = false								# Make the piece invisible for now
	camera = get_node("../../.././" + str(multiplayer.get_unique_id()) + "/Camera3D")
	print("Current camera: " + str(camera))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If currently dragging object
	if is_dragging:
		get_collided_objects()							# Find mouse position and raycast down until we hit an object

func _on_button_down():
	is_dragging = true									# Set the piece to dragging
	self.self_modulate.a = 0.3							# Make the button invisible

func _on_button_up():
	is_dragging = false									# Set the piece to dragging

# Function for raycasting from mouse position to find the map tile under the mouse
func get_collided_objects():
	var world = piece.get_world_3d().direct_space_state				# Get the world space the draggable object is in
	var mouse_pos:Vector2 = get_viewport().get_mouse_position()		# Get the current mouse position in the view port
	var start:Vector3 = camera.project_ray_origin(mouse_pos)		# Set start to the mouse position
	var end = camera.project_position(mouse_pos, RAYCAST_LENGTH)	# Set end to the mouse position but at the end of the ray
	var rayCast = PhysicsRayQueryParameters3D.create(start,end)		# Create the query (ray) between start and end
	var results:Dictionary = world.intersect_ray(rayCast)			# Get the collisions between the ray and the objects

	if results.size() > 0:		# We have a hit
		var collided_object:CollisionObject3D = results.get("collider")												# Get the collider of the object
		collided_object_id = results.get("collider_id")																# Get the ID of the collider
		piece.global_position = Vector3(collided_object.global_position.x, 2, collided_object.global_position.z)	# Set the global position of the piece to the map tile found
		piece.visible = true																						# Make the piece visible
	else:
		piece.global_position = Vector3(0, 0, 0)	# Reset the piece position
		piece.visible = false						# Hide the piece
		collided_object_id = null					# Set the ID to null to reset the last hit object

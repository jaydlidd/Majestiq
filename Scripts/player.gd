extends CharacterBody3D

@export var SPEED = 1000.0
@export var ZOOM_SPEED = 100.0
@export var MAX_HEIGHT = 30.0
@export var MIN_HEIGHT = 5.0

@onready var camera = $Camera3D
	
func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())						# Set the multiplayer authority to the player ID

func _physics_process(delta):
#	print($MultiplayerSynchronizer.get_multiplayer_authority())
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():		# If we currently control this player (based on ID above)
		camera.make_current()																	# Make the camera attached their current camera
		velocity = Vector3.ZERO																	# Set velocity to zero to ensure we stop moving with no input
		
		# Handle WASD key use for camera movement
		if Input.is_action_pressed("move_right"):
			velocity += Vector3.LEFT * SPEED * delta
		if Input.is_action_pressed("move_left"):
			velocity += Vector3.RIGHT * SPEED * delta
		if Input.is_action_pressed("move_down"):
			velocity += Vector3.FORWARD * SPEED * delta
		if Input.is_action_pressed("move_up"):
			velocity += Vector3.BACK * SPEED * delta
		
		# Handle camera zoom using mouse wheel
		if Input.is_action_just_pressed("mouse_scroll_down"):
			if get_position().y < MAX_HEIGHT:
				velocity += Vector3(0, 0.866025, -0.5) * ZOOM_SPEED								# See GDD Page 8 for calculations
		elif Input.is_action_just_pressed("mouse_scroll_up"):
			if get_position().y > MIN_HEIGHT:
				velocity += Vector3(0, -0.866025, 0.5) * ZOOM_SPEED								# See GDD Page 8 for calculations
				
		move_and_slide()																		# Update movement

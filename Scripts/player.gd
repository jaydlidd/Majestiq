extends CharacterBody3D

@export var SPEED = 100.0
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
			velocity += Vector3.DOWN * SPEED * delta
		if Input.is_action_pressed("move_up"):
			velocity += Vector3.UP * SPEED * delta
				
		move_and_slide()																		# Update movement

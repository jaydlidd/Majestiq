extends Node3D

@export var player_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for player in GameManager.players:								# For each player in the game
		var current_player = player_scene.instantiate()				# Create their player scene
		current_player.name = str(GameManager.players[player].id)	# Set the name of the player object to be the same as their MP game ID
		add_child(current_player)									# Add the player object to the scene

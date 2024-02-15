extends Node3D

@export var player_scene:PackedScene

# Preloaded map tiles
var sand_tile:PackedScene = preload("res://Scenes/sand_tile.tscn")
var grass_tile:PackedScene = preload("res://Scenes/grass_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for player in GameManager.players:								# For each player in the game
		var current_player = player_scene.instantiate()				# Create their player scene
		current_player.name = str(GameManager.players[player].id)	# Set the name of the player object to be the same as their MP game ID
		add_child(current_player)									# Add the player object to the scene
	
	# Generate the map tiles into the world
	generate_map_tiles(GameManager.map_tiles, GameManager.horizontal_tiles, GameManager.vertical_tiles)

# Design a map of tiles of a preset size with the available tiles
func generate_map_tiles(map:Array, x:int, y:int):
	var possible_tiles:Array = [sand_tile, grass_tile]		# A list of possible tiles to spawn
	var offset:float										# Variable to store the offset to align vertical hexagons
	var tile_count:int = 0									# A count of tiles used for naming and as an index for the map array
	var row_height:float = 3.6								# Float to know how high to place the next row so that tiles click
	var col_width:float = 4.8								# Float to know how far across to place the next column so that tiles click
	var rand_tile:Node										# Variable to hold the next tile to instantiate

	for i in range(x):
		# Determine if need to offset rows, odd rows offset by 50%
		if i % 2 == 0:
			offset = 0
		else:
			offset = 2.4
		
		rand_tile = match_tile(map[tile_count], tile_count)				# Pick random tile type
		rand_tile.name = str(tile_count) + "_" + rand_tile.name			# Name the tile so we can reference it
		rand_tile.position = Vector3((i * row_height), 0, 0 + offset)	# Set the tile position
		tile_count += 1													# Increment the counter
		add_child(rand_tile)
		
		for j in range(y - 1):
			rand_tile = match_tile(map[tile_count], tile_count)									# Pick random tile type
			rand_tile.name = str(tile_count) + "_" + rand_tile.name								# Name the tile so we can reference it
			rand_tile.position = Vector3((i * row_height), 0, ((j + 1) * col_width) + offset)	# Set the tile position
			tile_count += 1																		# Increment the counter
			add_child(rand_tile)

# Function to instantiate the tile based on the string entered
func match_tile(tile:String, tile_count:int):
	var new_tile:Node
	match tile:
		"sand":
			new_tile = sand_tile.instantiate()
		"grass":
			new_tile = grass_tile.instantiate()
			
	return new_tile

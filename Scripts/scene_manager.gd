extends Node3D

@export var player_scene:PackedScene

# Preloaded map tiles
var sand_tile:PackedScene = preload("res://Scenes/Map Tiles/sand_tile.tscn")
var grass_tile:PackedScene = preload("res://Scenes/Map Tiles/grass_tile.tscn")

# Preloaded pieces 
var knight_piece:PackedScene = preload("res://UI/Buttons/add_knight_button.tscn")
var farmer_piece:PackedScene = preload("res://UI/Buttons/farmer_piece.tscn")
var piece_button:Node
var count:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for player in GameManager.players:								# For each player in the game
		var current_player = player_scene.instantiate()				# Create their player scene
		current_player.name = str(GameManager.players[player].id)	# Set the name of the player object to be the same as their MP game ID
		add_child(current_player)									# Add the player object to the scene
	
		print(str(GameManager.players[player].id) + str(GameManager.players[player].inventory))
	# Generate the map tiles into the world
	generate_map_tiles(GameManager.map_tiles, GameManager.horizontal_tiles, GameManager.vertical_tiles)
	populate_inventory()
	
func populate_inventory():
	for player in GameManager.players:										# For each player in the game
		if GameManager.players[player].id == multiplayer.get_unique_id():	# If the current player id matches the player dict
			var pieces = GameManager.players[player].inventory
			for current_piece in pieces:									# Create the buttons for each piece
				match current_piece:
					"knight":
						piece_button = knight_piece.instantiate()	# Spawn the button
						piece_button.name = current_piece		# Name the piece by the provided name in the inventory
					"farmer":
						piece_button = farmer_piece.instantiate()	# Spawn the button
						piece_button.name = current_piece		# Name the piece by the provided name in the inventory
#				count += 1
#				piece_button.position = Vector2(8+(count*(100+8)),0)
				get_node("Inventory/HBoxContainer").add_child(piece_button)

# Design a map of tiles of a preset size with the available tiles
func generate_map_tiles(map:Array, x:int, y:int):
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
			new_tile.name = str(tile_count) + "_" + new_tile.name
		"grass":
			new_tile = grass_tile.instantiate()
			new_tile.name = str(tile_count) + "_" + new_tile.name
		
	return new_tile

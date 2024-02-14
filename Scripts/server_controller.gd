extends Control

var ip_address:String = "127.0.0.1"
var port:int = 8910
var peer:ENetMultiplayerPeer
var main_scene_path:String = "res://Scenes/main_game.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(player_connected)				# Call player_connected every time a peer connects
	multiplayer.peer_disconnected.connect(player_disconnected)			# Call player_disconnected every time a peer disconnects
	multiplayer.connected_to_server.connect(player_connected_to_server)	# Call player_connected_to_server every time a client connects to server
	multiplayer.connection_failed.connect(player_connected_failed)		# Call player_connected_failed every time a client fails to connect to server
	if "--server" in OS.get_cmdline_args():								# If we run the game in cmdline with args
		host_game()
	
	
func _on_host_button_down():
	host_game()

func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()								# Create a new peer connection
	peer.create_client(ip_address, port)							# Connect to the server
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)	# Compress connection to reduce lag
	multiplayer.set_multiplayer_peer(peer)							# Set the current connect to the peer (use our own connection to play)
	

func _on_start_game_button_down():
	start_game.rpc()												# Start the game on all clients

# Called on clients and servers when player connects
func player_connected(id):
	print("Player connected: " + str(id))
	
# Called on clients and servers when player connects
func player_disconnected(id):
	print("Player disconnected: " + str(id))

# Called only on clients when a player connects to a server
func player_connected_to_server():
	print("Player connected to server")
	send_player_info.rpc_id(1, multiplayer.get_unique_id())			# Send the client's id to the server
	
# Called only on clients when a player fails to connect to a server
func player_connected_failed():
	print("Player failed connected to server")

# Called to load the game scene into the tree and hide the server UI
@rpc("any_peer", "call_local")
func start_game():
	var scene = load(main_scene_path).instantiate()			# Create the main game scene
	get_tree().root.add_child(scene)								# Add the scene to the root tree
	self.hide()														# Hide the server UI

# Called to send client information 
@rpc("any_peer")
func send_player_info(id):
	if !GameManager.players.has(id):								# If a player is not already in the game, add it to the list of players
		GameManager.players[id] = {
			"id": id
		}
	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_info.rpc(GameManager.players[i].id)			# If this peer is the server, send information out to clients

func host_game():
	peer = ENetMultiplayerPeer.new()								# Create a new peer connection
	var error = peer.create_server(port)							# Host the server on given port
	if error != OK:													# If an error, then raise an error
		print("Server failed to host game with error: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)	# Compress connection to reduce lag
	multiplayer.set_multiplayer_peer(peer)							# Set the current connect to the peer (use our own connection to play)
	send_player_info(multiplayer.get_unique_id())					# Send server player's information
	print("Waiting for players...")

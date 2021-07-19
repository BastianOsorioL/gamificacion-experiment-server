extends Node2D

var port = 1909
var max_players = 100
var network = NetworkedMultiplayerENet.new()

func _ready():
	start_server()
	
func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started at Port ", port)
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")	

func _peer_connected(playerId):
	new_beginning(playerId)
	print("User ", str(playerId), " connected")

func _peer_disconnected(playerId):
	print("User ", str(playerId), " disconnected")
	
func new_beginning(playerId):
	$RPCClient.sendIdNewPlayer(playerId)
	$RPCClient.playersLog.append({
		"playerId" : playerId,
		"position" : Vector2(480, 260)
	})
	
	for players in $RPCClient.playersLog:
		$RPCClient.sendPlayers(players["playerId"], $RPCClient.playersLog)

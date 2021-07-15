extends Node

var playersLog = []
var timer = Timer.new()

func _ready():
	timerPosition()
	
remote func receive_hello(msg):
	print(msg)

func timerPosition():
	timer.set_wait_time(0.1)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "sendPosition")
	add_child(timer)
	timer.start()

func sendIdNewPlayer(playerId):
	rpc_unreliable_id(playerId, "receiverPlayerId", playerId)

func sendPlayers(playerId, players):
	rpc_unreliable_id(playerId, "receivePlayers", players)
	
func sendPosition():
	for players in playersLog:
		rpc_unreliable_id(players["playerId"], "receiveMove", playersLog)

remote func receiverPositionPlayer(playerId, position):
	for player in playersLog:
		if str(player["playerId"]) == str(playerId):
			player["position"] = position
			break
			

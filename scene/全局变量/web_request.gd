extends Node
var main_menu

var in_game:bool=false
func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connected_to_server.connect(_on_connection_success)
	
func _on_peer_connected(id):
	if main_menu and multiplayer.is_server():
		main_menu.start_game()#有人进来了，你也进去吧
	
	
	
#----------------------------------------------------------------------
	
	
	
func _on_connection_success():
	if main_menu:
		main_menu.start_game()

extends Node
var main_menu
var game

var in_game:bool=false

func _ready() -> void:
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connected_to_server.connect(_on_connection_success)
	
@rpc("any_peer","reliable")
func add_pen(id,name):
	if !game:
		await get_tree().scene_changed	
	game.add_pen(id,name)


func _on_peer_connected(id):
	if main_menu and multiplayer.is_server():
		main_menu.start_game()#有人进来了，你也进去吧

	if multiplayer.is_server():
		await get_tree().scene_changed	
		game.add_pen(id,Global.user_name)
	else:
		add_pen.rpc_id(1,id,Global.user_name)
	
	
	
#----------------------------------------------------------------------
	
	
	
func _on_connection_success():
	if main_menu:
		main_menu.start_game()
	

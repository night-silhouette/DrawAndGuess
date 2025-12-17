extends Node2D
@onready var 创建房间: Button = $选择/创建房间
@onready var 加入房间: Button = $选择/加入房间
@onready var back1: Button = $加入输入/back
@onready var back2: Button = $创建输入/back
@onready var exit: Button = $选择/exit
@onready var input_name: LineEdit = $选择/input_name


var page_list:Array[Node2D]=[]
@onready var 创建输入: Node2D = $创建输入
@onready var 加入输入: Node2D = $加入输入
@onready var 选择: Node2D = $选择
var page:int:
	set(value):
		page=value
		for item in page_list:
			item.visible=false
		page_list[page].visible=true
		
		


var user_name:String
func _ready() -> void:
	WebRequest.main_menu=self
	
	#页面管理
	page_list=[选择,加入输入,创建输入]
	page=0
	#ui信号绑定-------------------------------------start
	创建房间.pressed.connect(func():page=2)
	加入房间.pressed.connect(func():page=1)
	back1.pressed.connect(func():page=0)
	back2.pressed.connect(func():page=0)
	create_confirm.pressed.connect(create_servers)
	create_start_game.pressed.connect(start_game)
	close.pressed.connect(close_servers)
	join_confirm.pressed.connect(join_servers)
	exit.pressed.connect(func():get_tree().quit())
	input_name.text_submitted.connect(func(new_text):user_name=new_text)
	cancel.pressed.connect(cancel_client_connect)
	#ui信号绑定-------------------------------------end
	
	
func start_game():
	WebRequest.in_game=true
	Global.user_name=user_name
	get_tree().change_scene_to_file("res://scene/game/game.tscn")
	
	
# create 逻辑---------------------start
@onready var create_confirm: Button = $创建输入/确认
@onready var create_start_game: Button = $创建输入/start_game	
@onready var create_port_input: SpinBox = $创建输入/port_input	
@onready var close: Button = $创建输入/close
func create_servers():
	var port:int=int(create_port_input.value)
	if !port:
		Util.pop_remind("警告","请输入监听的端口号")
		return
	var peer = ENetMultiplayerPeer.new()
	var error:Error=peer.create_server(port)
	if error!=OK:
		Util.pop_remind("报错提示","创建失败,错误码："+str(error))
	else:
		multiplayer.multiplayer_peer = peer
		Util.pop_remind("创建成功","等待玩家加入或先进入")
		$"创建输入/Label2".visible=false
		create_port_input.visible=false
		create_start_game.visible=true
		close.disabled=false
	
func close_servers():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		$"创建输入/Label2".visible=true
		create_port_input.visible=true
		create_start_game.visible=false
		close.disabled=true	
		Util.pop_remind("成功","已关闭房间")
	
# create 逻辑---------------------end


# join 逻辑-----------------------start
@onready var join_confirm: Button = $加入输入/确认
@onready var join_ip_input: LineEdit = $加入输入/ip_input
@onready var join_port_input: SpinBox = $加入输入/port_input
@onready var cancel: Button = $加入输入/取消连接


func join_servers():
	var ip:String = join_ip_input.text
	var port:int = int(join_port_input.value)
	if !ip:
		Util.pop_remind("警告","请输入ip")
		return
	if !port:
		Util.pop_remind("警告","请输入port")
		return
	if !ip.is_valid_ip_address():
		Util.pop_remind("警告","请输入合法的ip")
		return
	var peer = ENetMultiplayerPeer.new()
	var error=peer.create_client(ip,port)
	if error==OK:
		Util.pop_remind("提示","加入中")
		join_confirm.disabled=true	
		multiplayer.multiplayer_peer = peer
		cancel.disabled=false
	else:
		Util.pop_remind("报错提示","加入失败，错误码："+str(error))
	
func cancel_client_connect():
	multiplayer.multiplayer_peer.close()
	cancel.disabled=true
	join_confirm.disabled=false

# join 逻辑-----------------------end














	
	
	
	

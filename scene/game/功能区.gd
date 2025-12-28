extends Node2D
var pen
@onready var game: Node2D = $".."

@onready var color_picker_button1: ColorPickerButton = $画笔颜色/ColorPickerButton
@onready var color_picker_button2: ColorPickerButton = $画板颜色/ColorPickerButton
@onready var button3: Button = $删除/Button
@onready var button4: Button = $撤回/Button
@onready var button5: Button = $保存/Button
@onready var button6: Button = $粗细/Button
@onready var button7: Button = $Leave/Button
@onready var spin_box: SpinBox = $粗细/SpinBox

@onready var file_dialog: FileDialog = $保存/FileDialog


@onready var canvas: Control = $"../background/canvas"


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clear"):
		canvas.clear_canvas()
	if Input.is_action_just_pressed("redo"):
		canvas.redo()
	if Input.is_action_just_pressed("save"):
		on_save()
var viewport:Viewport

var temp
var view_scale#缩放比
func _ready() -> void:
	
	var DESIGN_RESOLUTION: Vector2 = get_viewport().get_visible_rect().size
	var actual_viewport_size: Vector2 = Vector2(DisplayServer.window_get_size())
	temp=(actual_viewport_size / DESIGN_RESOLUTION).x
	view_scale=Vector2(temp,temp)
	viewport=get_viewport()
	
	
	button5.pressed.connect(on_save)
	color_picker_button1.color_changed.connect(func(color:Color):
		canvas.change_color(color)
		if multiplayer.is_server():
			pen.modulate=color
		else :
			change_pen_modulate.rpc_id(1,multiplayer.get_unique_id(),color)
		)
	color_picker_button2.color_changed.connect(func(color:Color):
		canvas.change_canvas_color.rpc(color)
		)	#改颜色
		
		
	#改鼠标逻辑
	color_picker_button1.pressed.connect(func():
		game.switch_mouse(false)
		color_picker_button1.popup_closed.connect(func():game.switch_mouse(true),CONNECT_ONE_SHOT)
		)
	color_picker_button2.pressed.connect(func():
		game.switch_mouse(false)
		color_picker_button2.popup_closed.connect(func():game.switch_mouse(true),CONNECT_ONE_SHOT)
		)	
		
	button3.pressed.connect(func():
		canvas.clear_canvas()
		)	
	button4.pressed.connect(func():
		canvas.redo()
		)
		
	button6.pressed.connect(func():
		if spin_box.visible:
			spin_box.visible=false
		else:
			spin_box.visible=true
		
		)
	button7.pressed.connect(func() :
		if !WebRequest.is_multiplayer:
			game.switch_mouse(false)
			WebRequest.is_multiplayer=true
			get_tree().change_scene_to_file("res://scene/main_menu/main_menu.tscn")
		else:
			game.switch_mouse(false)
			if multiplayer.is_server():
				client_leave.rpc()
				Util.set_time(3,close_servers)
			else:
				close_servers()
			get_tree().change_scene_to_file("res://scene/main_menu/main_menu.tscn")
			
		)
		
	spin_box.value_changed.connect(func(value):canvas.change_width(value))

@onready var pen_container: Node2D = $"../pen_container"		
@rpc("any_peer","reliable")
func change_pen_modulate(id,color):	
		for item in pen_container.get_children():
			if item.id==id:
				item.modulate=color
func on_save():
	var now_time=str(Time.get_unix_time_from_system())
	game.switch_mouse(false)
	var tex:ViewportTexture=viewport.get_texture()
	var img:Image=tex.get_image()
	var crop_rect:Rect2
	crop_rect.position=canvas.get_screen_position()*view_scale
	crop_rect.size=Vector2(500,500)*view_scale
	img=img.get_region(crop_rect)
	file_dialog.popup_centered()
	var on_selected=func(path):
		game.switch_mouse(true)
		img.save_png(path+"/"+now_time+".png")
	file_dialog.dir_selected.connect(on_selected,CONNECT_ONE_SHOT)
	file_dialog.canceled.connect(func():
		game.switch_mouse(true)
		file_dialog.dir_selected.disconnect(on_selected))

func close_servers():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer=null

@rpc("any_peer","reliable")
func client_leave():
	game.switch_mouse(false)
	Util.pop_remind("提示","房间被关闭,3秒后返回主菜单")
	Util.set_time(3,func():get_tree().change_scene_to_file("res://scene/main_menu/main_menu.tscn"))	
	close_servers()

extends Node2D



var pen:
	set(value):
		pen=value
		switch_mouse(true)
		mod.pen=pen
const PEN = preload("uid://dnrylskj1vun4")

@onready var mod: Node2D = $功能区

@onready var pen_container: Node2D = $pen_container

func add_pen(id,name):
	var temp=PEN.instantiate()
	temp.id=id
	temp.labelText=name if name else "player"+str(id)
	temp.name="pen"+str(id)
	pen_container.add_child(temp)
	
	
	
func switch_mouse(flag:bool):#切换画笔
	Input.set_mouse_mode(1 if flag else 0)
	pen.visible=flag
var my_id
func _ready() -> void:
	my_id=multiplayer.get_unique_id()
	WebRequest.game=self
	
@rpc("any_peer","unreliable")
func update_pen_position(id,position):
	for item in pen_container.get_children():
		if item.id and item.id == id:
			item.global_position=position
func _process(delta: float) -> void:
	if pen :
		var viewport: Viewport = get_viewport()
		var mouse_viewport_position: Vector2 = viewport.get_mouse_position()
		if multiplayer.is_server():
			pen.global_position=mouse_viewport_position
		else:
			update_pen_position.rpc_id(1,my_id,mouse_viewport_position)
			
			
			
			
			

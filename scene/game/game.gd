extends Node2D



@onready var pen: Sprite2D = $画笔/画笔


func switch_mouse(flag:bool):#切换画笔
	Input.set_mouse_mode(1 if flag else 0)
	pen.visible=flag

func _ready() -> void:
	switch_mouse(true)

func _process(delta: float) -> void:
	var viewport: Viewport = get_viewport()
	var mouse_viewport_position: Vector2 = viewport.get_mouse_position()
	pen.global_position=mouse_viewport_position
	

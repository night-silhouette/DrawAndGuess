extends Node2D

#———————————————————组件接口—————————————————————————————s


#----------------组件初始化参数---------s
@export var canvas_rect:Vector2=Vector2(500,500)
@export var canvas_color:Color=Color("black")
@export var init_pen_color:Color=Color("white")
@export var init_pen_width:float=1.0
#----------------组件初始化参数---------e



func clear_canvas():#清除画板
	pass
func redo():#撤回上一笔
	pass
func change_color():#改变画笔颜色
	pass
func change_width():#改变画笔宽度
	pass

func switch_pen():
	pass
func switch_select():
	pass

#————————————————————组件接口————————————————————————————E


func change_canvas_color(color:Color):
	var current_style: StyleBox = canvas.get_theme_stylebox("panel")
	current_style.set_bg_color(color)

@onready var canvas: Panel = $canvas
func _ready() -> void:
	canvas.size=canvas_rect
	change_canvas_color(canvas_color)
	canvas.pen_color=init_pen_color
	canvas.pen_width=init_pen_width

	
	
	
	
	
	
	
	
	
	
	
	
	
	

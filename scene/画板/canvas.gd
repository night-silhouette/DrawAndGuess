extends Panel

@onready var parent: Control = $".."


#var stroke_others_player:Array[stroke]=[]

@onready var stroke_on_canvas:ObservableArray=ObservableArray.new()
var pen_width:float
var pen_color:Color

var _current_stroke:stroke
func _gui_input(event: InputEvent) -> void:

	if event is InputEventMouseButton and event.pressed:
		_current_stroke=stroke.new(pen_width,pen_color)
		stroke_on_canvas.push_back(_current_stroke)
		_current_stroke.point_list.push_back(event.position)
		queue_redraw()
	if event is InputEventMouseMotion and event.button_mask==1:
		if _current_stroke and parent.canvas_rect.x>event.position.x and parent.canvas_rect.y>event.position.y and event.position.y>0 and event.position.x>0:
			_current_stroke.point_list.push_back(event.position)
		queue_redraw()
		
		
	if event is InputEventMouseButton and !event.pressed:
		_current_stroke=null
		queue_redraw()
		
func _draw() -> void:
	stroke_on_canvas.foreach(func(item):
		draw_polyline(item.point_list,item.pen_color,item.pen_width,true))
		

	
	
	
	
	
	
	
	
	
	
	

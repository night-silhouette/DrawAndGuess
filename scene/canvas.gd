extends Panel

class stroke extends RefCounted:
	var pen_width:float
	var pen_color:Color
	var point_list:PackedVector2Array
	func _init(_pen_width,_pen_color) -> void:
		self.pen_width=_pen_width
		self.pen_color=_pen_color
		self.point_list=[]

var stroke_on_canvas:Array[stroke]=[]
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
		if _current_stroke:
			_current_stroke.point_list.push_back(event.position)
		queue_redraw()
		
		
	if event is InputEventMouseButton and !event.pressed:
		_current_stroke=null
		queue_redraw()
		
func _draw() -> void:
	for item in stroke_on_canvas:
		draw_polyline(item.point_list,item.pen_color,item.pen_width)
	
	
	
	
	
	
	
	
	
	
	
	

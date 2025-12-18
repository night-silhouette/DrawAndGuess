extends Panel

@onready var parent: Control = $".."
@onready var game: Node2D = $"../../.."


var stroke_others_player:Array[stroke]=[]

var stroke_on_canvas:ObservableArray=ObservableArray.new()

@rpc("any_peer")
func add_stroke(value:Dictionary):
	stroke_others_player.push_back(stroke.from_dict(value))
	queue_redraw()
@rpc("any_peer")
func update_stroke(id,point):
	for item in stroke_others_player:
		if item.id==id:
			item.point_list.push_back(point)
	queue_redraw()
	

func _ready() -> void:
	stroke_on_canvas.changed.connect(func(op_type,index,value:stroke):
		if op_type=="add":
			add_stroke.rpc(value.to_dict())
		)
	
	

var pen_width:float
var pen_color:Color


var _current_stroke:stroke
func _gui_input(event: InputEvent) -> void:

	if event is InputEventMouseButton and event.pressed:
		var unix_time = Time.get_unix_time_from_system()
		var id = str(unix_time)+str(game.my_id)
		_current_stroke=stroke.new(pen_width,pen_color,id)
		stroke_on_canvas.push_back(_current_stroke)
		_current_stroke.point_list.push_back(event.position)
		update_stroke.rpc(_current_stroke.id,event.position)
		queue_redraw()
	if event is InputEventMouseMotion and event.button_mask==1:
		if _current_stroke and parent.canvas_rect.x>event.position.x and parent.canvas_rect.y>event.position.y and event.position.y>0 and event.position.x>0:
			_current_stroke.point_list.push_back(event.position)
			update_stroke.rpc(_current_stroke.id,event.position)
		queue_redraw()
		
		
	if event is InputEventMouseButton and !event.pressed:
		_current_stroke=null
		queue_redraw()
		
func _draw() -> void:
	stroke_on_canvas.foreach(func(item):
		draw_polyline(item.point_list,item.pen_color,item.pen_width,true))
	for item in stroke_others_player:
		draw_polyline(item.point_list,item.pen_color,item.pen_width,true)
		

	
	
	
	
	
	
	
	
	
	
	

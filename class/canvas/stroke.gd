extends RefCounted
class_name stroke 
var pen_width:float
var pen_color:Color
var point_list:PackedVector2Array
func _init(_pen_width,_pen_color) -> void:
	self.pen_width=_pen_width
	self.pen_color=_pen_color
	self.point_list=[]


func to_dict() -> Dictionary:
	return {
		"w": pen_width,
		"c": pen_color,
		"p": point_list
		}

static func from_dict(data: Dictionary) -> stroke:
	var s = stroke.new(data.w, data.c)
	s.point_list = data.p
	return s

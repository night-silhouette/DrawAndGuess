extends Sprite2D


@onready var color_picker_button: ColorPickerButton = $ColorPickerButton
@onready var canvas: Node2D = $"../canvas"


func _ready() -> void:
	color_picker_button.color_changed.connect(func(color:Color):
		canvas.change_canvas_color(color)
		)
		
		
		

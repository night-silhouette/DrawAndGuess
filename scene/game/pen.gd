extends Sprite2D


var game
@export var id:int
@onready var label: Label = $Label
@export var labelText:String
func _ready() -> void:
	label.text=labelText
	game=get_tree().current_scene
	if multiplayer.get_unique_id()==id:
		game.pen=self
	
		
	

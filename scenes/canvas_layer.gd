extends CanvasLayer

@onready var win_ui: Control = $winUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_ui.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_win_body_entered(_body: Node2D) -> void:
	win_ui.visible = true

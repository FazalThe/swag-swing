extends Node2D

@onready var r1: Node2D = $R1
@onready var tween
@onready var init = r1.position
@onready var up

func _ready():
	while true:
		await move_cycle()

func move_cycle():
	up = init + Vector2(0, -193)

	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)

	tween.tween_property(r1, "position", up, 5)
	tween.tween_interval(0.5)
	tween.tween_property(r1, "position", init, 5)
	tween.tween_interval(0.5)
	
	await tween.finished

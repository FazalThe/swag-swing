extends Sprite2D

@onready var gc = get_parent()
@onready var cross_hair: Sprite2D = $"."

var tween
var was_colliding = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var is_colliding = gc.ray.is_colliding()
	print(is_colliding)
	if was_colliding and not is_colliding :
		tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(cross_hair,"modulate",Color(1.0, 1.0, 1.0, 1.0),0.234)

	if not was_colliding and is_colliding :
		tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(cross_hair,"modulate",Color(0.609, 1.0, 0.42, 1.0),0.234)

	was_colliding = is_colliding

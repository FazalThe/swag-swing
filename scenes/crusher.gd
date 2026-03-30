extends Node2D

@onready var ani: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var crushref: Node2D = $"."


@onready var crush: AnimatableBody2D = $AnimatableBody2D


@onready var posu: Vector2 = Vector2(0,0)
@onready var posd: Vector2 = posu + Vector2(0,30)
@onready var tween


func _physics_process(_delta: float) -> void:
	
	pass
	
func _on_timer_timeout() -> void:
	ani.play("default")

	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(crush,"position",posd,0.234)
	tween.tween_property(crush,"position",posu,0.234)
	tween.tween_property(crush,"position",posu,1.532)

	
func kill_tween() -> void:
	if tween :
		tween.kill()

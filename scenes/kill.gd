extends Area2D

@onready var killtime: Timer = $killtime


func _on_body_entered(body: Node2D) -> void:
	print("lask")
	killtime.start()

func _on_killtime_timeout() -> void:
	get_tree().reload_current_scene()

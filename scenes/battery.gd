extends Control
@onready var bar1: ProgressBar = $HBoxContainer/ProgressBar
@onready var bar2: ProgressBar = $HBoxContainer/ProgressBar2
@onready var bar3: ProgressBar = $HBoxContainer/ProgressBar3
@onready var bar4: ProgressBar = $HBoxContainer/ProgressBar4
@onready var plyer: CharacterBody2D = $"../../Player"

@onready var charge

	


func _physics_process(delta: float) -> void:
	charge = plyer.charge
	bar1.value = charge
	bar2.value = charge
	bar3.value = charge
	bar4.value = charge

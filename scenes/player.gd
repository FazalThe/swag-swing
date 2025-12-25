extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 0.1
const DECELERATION = 0.1

@onready var gc := $GrappleControl
@onready var ani: AnimatedSprite2D = $AnimatedSprite2D
@onready var hand: Sprite2D = $"AnimatedSprite2D/Grappling Hand/Sprite2D"



func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if gc.launched == true:
		hand.show()
		ani.play("grap")
	if gc.launched == false:
		hand.hide()
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = lerp(velocity.x, SPEED * direction, ACCELERATION)
		else:
			velocity.x = lerp(velocity.x, 0.0, DECELERATION)
		if is_on_floor():
			if direction == 1:
				ani.play("run")
				ani.flip_h = false
			elif direction == -1:
				ani.flip_h = true
				ani.play("run")
			else:
				ani.play("idle")
	if Input.is_action_just_pressed("jump") && (is_on_floor() || gc.launched):
		velocity.y += JUMP_VELOCITY
		gc.retract()
		ani.play("jump")
	move_and_slide()

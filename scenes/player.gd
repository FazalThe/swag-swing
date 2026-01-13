extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 0.15
const DECELERATION = 0.15

@onready var gc := $GrappleControl
@onready var ani: AnimatedSprite2D = $AnimatedSprite2D
@onready var hand: Sprite2D = $"Grappling Hand/Sprite2D"
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
@onready var charge = 100



func _physics_process(delta):
	charge = gc.charge
	if not is_on_floor():
		velocity += get_gravity() * delta
		if gc.launched == false:
			ani.play("air")
	if gc.launched == true:
		#ani.hide()
		ani.play("grap")

		
	if gc.launched == false:
		
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
	if Input.is_action_just_pressed("jump") && (is_on_floor() || gc.launched or !timer.is_stopped()):
		velocity.y += JUMP_VELOCITY
		gc.retract()
		ani.play("jump")
	var was_on_floor = is_on_floor()


	move_and_slide()
	if is_on_floor() != was_on_floor :
		timer.start()
		
	

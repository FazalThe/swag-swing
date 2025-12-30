extends Node2D

@export var rest_length = 10
@export var stiffness = 110.0


@onready var player := get_parent()
@onready var ray := $RayCast2D
@onready var rope := $Line2D
@onready var hand: Node2D = $"../Grappling Hand"
@onready var hand_sprite: Sprite2D = $"../Grappling Hand/Sprite2D"
@onready var ani: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var ani2: AnimatedSprite2D = $"../AnimatedSprite2D2"





var launched = false
var target: Vector2
var gstart: Vector2


func _process(delta):
	ray.global_position = gstart
	if launched == false:
		ani2.hide()
		ani.show()
		hand_sprite.hide()
	#hand position
	if launched == true:
		ani.flip_h = false
		hand_sprite.show()
		var dist = ray.global_position.direction_to(target)
		var dir = ray.global_position.direction_to(target)
		
		#hand.global_rotation = -acos(dist[0])
		hand.look_at(target)
		if dir[0] > 0.7:
			ani.show()
			ani2.hide()

		elif dir[0] < -0.7:
			ani.hide()
			ani2.show()

	#grapple
	ray.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("grapple"):
		launch()
	if Input.is_action_just_released("grapple"):
		retract()
	
	if launched:
		handle_grapple(delta)

func launch():
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()

func retract():
	launched = false
	rope.hide()

func handle_grapple(delta):
	var target_dir = ray.global_position.direction_to(target)
	var target_dist = ray.global_position.distance_to(target)
	var displacement = target_dist - rest_length
	var damp = 0.2 * displacement
	var force = Vector2.ZERO
	var center = hand.global_position
	gstart = center+ (target_dir*22.5)
	
	if displacement > 0:
		var spring_force_magnitude = log(stiffness) * displacement * 10
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping = -damp * vel_dot * target_dir
		
		force = spring_force + damping
	player.velocity += force * delta
	
	update_rope()
#finding position for rope start

func update_rope():
	rope.set_point_position(1, to_local(target))
	rope.set_point_position(0, to_local(gstart))
	

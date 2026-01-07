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
@onready var crosshair: Sprite2D = $CrossHair





var launched = false
var target: Vector2
var gstart: Vector2
var target_dist
var target_dir


func _process(delta):

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
	
	cross_pos()
	
func launch():
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		crosshair.global_position = target
		rope.show()
func retract():
	launched = false
	rope.hide()

func handle_grapple(delta):
	target_dir = hand.global_position.direction_to(target)
	var center = hand.global_position
	target_dir[0] -= 0.2
	gstart = center+ (target_dir*22.5)
	ray.global_position = gstart
	target_dist = ray.global_position.distance_to(target)
	var displacement = target_dist - rest_length
	
	#cross hair position
	crosshair.global_position = target

	var damp = 0.2 * displacement
	var force = Vector2.ZERO

	#print(displacement)
	#print(target_dist)
	
	if target_dist > 0:
		var spring_force_magnitude = log(stiffness) * displacement * 10
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping = -damp * vel_dot * target_dir
		
		force = spring_force + damping
	player.velocity += force * delta
	
	update_rope()

#finding position for rope start
func cross_pos():
	var pos = hand.global_position
	var scale = 0.15
	if launched == false:
		if ray.is_colliding() == false:
			crosshair.global_position = pos+(pos.direction_to(get_global_mouse_position()) *1300 * scale)
			
		else:
			crosshair.global_position = ray.get_collision_point()

func update_rope():
	rope.set_point_position(1, to_local(target))
	rope.set_point_position(0, to_local(gstart))
	

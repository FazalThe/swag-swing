extends Node2D

@export var rest_length = 0
@export var stiffness = 15.0
@export var damping = 10

@onready var player := get_parent()
@onready var ray := $RayCast2D
@onready var rope := $Line2D
@onready var hand: Node2D = $"../Grappling Hand"
@onready var body: Node2D = $"../Grappling Hand/Body"
@onready var body2: Node2D = $"../Grappling Hand/Body2"
@onready var ani: AnimatedSprite2D = $"../Grappling Hand/Body/AnimatedSprite2D"
@onready var ani2: AnimatedSprite2D = $"../Grappling Hand/Body2/AnimatedSprite2D"
@onready var hand_sprite: Sprite2D = $"../Grappling Hand/Sprite2D"





var launched = false
var target: Vector2


func _process(delta):
	if launched == false:
		ani.hide()
		ani2.hide()
		hand_sprite.hide()
	#hand position
	if launched == true:
		hand_sprite.show()
		ani.play("grap")
		ani2.play("grap")
		var dist = (player.global_position.direction_to(target))
		var dir = player.global_position.direction_to(target)
		print(dir)
		hand.global_rotation = -acos(dist[0])
		if dir[0] > 0:
			ani.show()
			ani2.hide()
			body.global_rotation = acos(dist[0]) - 1.55
		elif dir[0] < 0:
			ani.hide()
			ani2.show()
			body2.global_rotation = acos(dist[0]) - 1.55


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
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	var displacement = target_dist - rest_length
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping = -damping * vel_dot * target_dir
		
		force = spring_force + damping
		
	player.velocity += force * delta
	
	update_rope()
#finding position for rope start

func update_rope():
	rope.set_point_position(1, to_local(target))

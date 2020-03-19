extends KinematicBody

const ACCELERATION = 0.1
const DECELERATION = 0.05

onready var home = $Position3D

var movement_speed = 0
var direction = Vector3()
var my_rotation = Vector2()
var movement = Vector3()
var is_turned = false

func _ready():
	home.set_as_toplevel(true)
	direction = global_transform.basis.z.normalized()

func _process(delta):
	
	movement_speed = lerp(movement_speed, 3, delta)
	
	# Acceleration
	var hVel = movement
	hVel.y = 0
	var target = direction * movement_speed
	var acceleration
	if direction.dot(hVel) > 0:
		acceleration = ACCELERATION
	else:
		acceleration = DECELERATION
	
	hVel = hVel.linear_interpolate(target, acceleration * movement_speed * delta)
	movement.x = hVel.x
	movement.z = hVel.z

	if transform.origin.distance_to(home.transform.origin) > 10:
		is_turned = true
		direction = transform.origin.direction_to(home.transform.origin)
		look_at(direction, Vector3(0, 1, 0))
		
	rotation_degrees.y = rad2deg(atan2(movement.x, movement.z))
	movement = lerp(movement, direction, delta)
	move_and_slide(movement)

func _on_Area_body_entered(body):
	pass # Replace with function body.

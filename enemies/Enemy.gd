extends KinematicBody

const ACCELERATION = 0.1
const DECELERATION = 0.05

var movement_speed = 0
var direction = Vector3()
var my_rotation = Vector2()
var movement = Vector3()

func _process(delta):
	movement = Vector3()
	movement_speed = lerp(movement_speed, 3, delta)
	
	direction = global_transform.basis.z.normalized()
	
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
	
	movement = move_and_collide(movement)

extends KinematicBody

const ACCELERATION = 0.1
const DECELERATION = 0.05

export (NodePath) var patrol_path

onready var home = $Position3D
onready var camera = $Camera

var movement_speed = 0
var direction = Vector3()
var my_rotation = Vector2()
var movement = Vector3()
var is_turned = false
var target_rot = Vector3()
var look_pos = Vector3()
var patrol_points
var patrol_index = 0

func _ready():
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
	
func _process(delta):
	
	movement_speed = clamp(movement_speed, 3, delta)
	movement.y -= 10 * delta
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
	
	if !patrol_path:
		return
	var patrol_target = patrol_points[patrol_index]
	if get_transform().origin.distance_to(patrol_target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0 , patrol_points.size())
		patrol_target = patrol_points[patrol_index]
		look_at(patrol_points[patrol_index], Vector3(0, 1, 0))
	
	
	movement = (patrol_target - get_transform().origin).normalized() * movement_speed
	movement = move_and_slide(movement)

func _on_Area_body_entered(body):
	pass # Replace with function body.

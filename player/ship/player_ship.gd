extends Spatial

const ACCELERATION = 0.1
const DECELERATION = 1.0
const GRAVITY = -1000.0
const DEFAULT_CAMERA_POSITION = Vector3(1, 6, -6)

export(float) var mouse_sensitivity = 1
export(float) var rotation_limit = 25
export(float) var max_zoom = 0.5
export(float) var min_zoom = 1.5
export(float) var zoom_speed = 2

# player stuff
var velocity = Vector3()
var movement_speed = 0
var normal_speed = 3
var sprint_speed = 7
var is_moving = false
var direction = Vector3()
var my_rotation = Vector2()
var speed = Vector3()
var movement = Vector3()
var rotation_speed = 2

# camera stuff
var yaw = 0
var camera_move_time = .5
var base_camera_flag = true
var no_buttons = true
var zoom_factor = 1
var actual_zoom = 1

onready var sail1 = $"../Mesh/SailFront"
onready var sail2 = $"../Mesh/SailMid"
onready var sail3 = $"../Mesh/SailRear"
onready var gimbal = $InnerGimbal
onready var camera = $InnerGimbal/Camera
onready var camera_cast = $InnerGimbal/Camera/RayCast
onready var my_model = $"../Mesh"
onready var collider = $"../CollisionShape"

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	movement_speed = normal_speed
	camera_cast.add_exception(get_parent())

func _unhandled_input(event):

	if event is InputEventMouseMotion:
		#essentially turn rate
		yaw = fmod(yaw - event.relative.x * mouse_sensitivity/100, 360)
		rotation = Vector3(0, deg2rad(yaw), 0)
		my_rotation = event.relative

func _physics_process(delta):
	
	# Ship movement
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var accept = Input.is_action_just_pressed("ui_accept")
	var sprint = Input.is_action_just_pressed("shift")
	var aim = camera.get_camera_transform().basis
	
	if sail1.scale.z > 1:
		sail1.scale.z -= 0.1
		sail2.scale.z -= 0.1
		sail3.scale.z -= 0.1
	
	if up:
		direction -= aim[2]
		if sail1.scale.z < 5:
			sail1.scale.z += 0.3
			sail2.scale.z += 0.3
			sail3.scale.z += 0.3
		else:
			sail1.scale.z -= 0.1
			sail2.scale.z -= 0.1
			sail3.scale.z -= 0.1
	if down:
		movement /= 1.12
#	if left:
#		direction -= aim[0]
#	if right:
#		direction += aim[0]
	if up:
		is_moving = true
		if sprint and sail1.scale.z < 6 and movement_speed > 2.5:
			movement_speed = sprint_speed
			sail1.scale.z += 3
			sail2.scale.z += 3
			sail3.scale.z += 3
		else:
			movement_speed = lerp(movement_speed, normal_speed, delta)
	else:
		movement_speed = 0
		#direction = Vector3()
		is_moving = false

	movement.y += GRAVITY * delta * 0.3
		
	direction = direction.normalized()
	
	# Acceleration
	var hVel = movement
	hVel.y = 0
	var target = direction * movement_speed
	var acceleration
	if direction.dot(hVel) >= 0:
		acceleration = ACCELERATION
	else:
		acceleration = DECELERATION
	
	hVel = hVel.linear_interpolate(target, acceleration * movement_speed * delta)
	movement.x = hVel.x
	movement.z = hVel.z
	
	movement = get_parent().move_and_slide(movement)

	if camera_cast.is_colliding():
		camera.global_transform.origin = camera_cast.get_collision_point()
	else:
		camera.translation = DEFAULT_CAMERA_POSITION
	
	#Player Rotation
	if is_moving:
		var angle = atan2(movement.x, movement.z)
		var player_rotation = get_rotation()
		
		#player_rotation.y = angle
		my_model.rotation = lerp(my_model.rotation, player_rotation, delta)
	
	#Camera Rotation
	gimbal.rotate_x(deg2rad(my_rotation.y) * delta * mouse_sensitivity * 3)
	gimbal.rotation_degrees.x = clamp(gimbal.rotation_degrees.x, -rotation_limit, rotation_limit)
	
	my_rotation = Vector2()

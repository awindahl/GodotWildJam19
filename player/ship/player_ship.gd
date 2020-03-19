extends Spatial

const ACCELERATION = 0.1
const DECELERATION = 0.05
const GRAVITY = -1000.0
const DEFAULT_CAMERA_POSITION = Vector3(1, 6, -6)
const ZOOMED_CAMERA_POSITION = Vector3(1, 4.1, -4)
const CANNONBALL = preload("res://player/ship/cannonball.tscn")

export(float) var mouse_sensitivity = 1
export(float) var rotation_limit = 25
export(float) var max_zoom = 0.5
export(float) var min_zoom = 1.5
export(float) var zoom_speed = 2
export(bool) var is_zoomed = false

# player stuff
var velocity = Vector3()
var movement_speed = 0
var normal_speed = 3
var sprint_speed = 4
var is_moving = false
var direction = Vector3()
var my_rotation = Vector2()
var speed = Vector3()
var movement = Vector3()
var rotation_speed = 2
var can_shoot = true

# camera stuff
var yaw = 0
var camera_move_time = .5
var base_camera_flag = true
var no_buttons = true
var zoom_factor = 1
var actual_zoom = 1

var camera_min_fov = 70
var camera_max_fov = 90

onready var sail1 = $"../Ship/SailFront"
onready var sail2 = $"../Ship/SailMid"
onready var sail3 = $"../Ship/SailRear"
onready var gimbal = $InnerGimbal
onready var camera = $InnerGimbal/Camera
onready var camera_cast = $InnerGimbal/Camera/RayCast
onready var my_model = $"../Ship"
onready var collider = $"../CollisionShape"
onready var aim_assist_r = $"../Ship/AimArrowRight"
onready var aim_assist_l = $"../Ship/AimArrowLeft"
onready var cannon1 = $"../Ship/Cannon"
onready var cannon2 = $"../Ship/Cannon2"
onready var cannon3 = $"../Ship/Cannon3"
onready var cannon4 = $"../Ship/Cannon4"


func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	movement_speed = normal_speed
	camera_cast.add_exception(get_parent())
	camera.translation = DEFAULT_CAMERA_POSITION

func _unhandled_input(event):

	if event is InputEventMouseMotion:
		yaw = fmod(yaw - event.relative.x * mouse_sensitivity/100, 360)
		rotation = Vector3(0, deg2rad(yaw), 0)
		my_rotation = event.relative
		
		if gimbal.rotation_degrees.x < 0:
			aim_assist_r.scale.z = gimbal.rotation_degrees.x/3 * -1
			aim_assist_l.scale.z = gimbal.rotation_degrees.x/3 * -1
		

func _physics_process(delta):
	
	# Ship movement
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var accept = Input.is_action_just_pressed("ui_accept")
	var sprint = Input.is_action_just_pressed("shift")
	var aim = camera.get_camera_transform().basis
	var right_click = Input.is_action_pressed("right_click")
	var left_click = Input.is_action_just_pressed("left_click")
	
	camera.fov = clamp(movement.length() * 10, 70, 100)
	
	if sail1.scale.z > 1:
		sail1.scale.z -= 0.1
		sail2.scale.z -= 0.1
		sail3.scale.z -= 0.1
	
	if up:
		direction -= aim[2]
		print(direction)
		
		if sail1.scale.z < 5:
			sail1.scale.z += 0.3
			sail2.scale.z += 0.3
			sail3.scale.z += 0.3
		else:
			sail1.scale.z -= 0.1
			sail2.scale.z -= 0.1
			sail3.scale.z -= 0.1
			
		is_moving = true
		if sprint and sail1.scale.z < 6 and movement_speed > 2:
			movement_speed += 2
			sail1.scale.z += 3
			sail2.scale.z += 3
			sail3.scale.z += 3
		else:
			movement_speed = lerp(movement_speed, normal_speed, delta)
	else:
		direction = Vector3()
		is_moving = false
		
	if down:
		movement /= 1.08
	
	movement.y += GRAVITY * delta * 0.3
		
	direction = direction.normalized()
	
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
	
	movement = get_parent().move_and_slide(movement)
	
	#Player Rotation
	if is_moving:
		var angle = atan2(movement.x, movement.z)
		var player_rotation = get_rotation()
		
		#player_rotation.y = angle
		my_model.rotation = lerp(my_model.rotation, player_rotation, delta)
		collider.rotation = lerp(my_model.rotation, player_rotation, delta)
	
	#Camera Rotation
	gimbal.rotate_x(deg2rad(my_rotation.y) * delta * mouse_sensitivity)
	gimbal.rotation_degrees.x = clamp(gimbal.rotation_degrees.x, -rotation_limit, rotation_limit)
	
	my_rotation = Vector2()
	
func _input(event):
	if event.is_action_pressed("right_click"):
		$"../AnimationPlayer".play("Focus")
	
	if event.is_action_released("right_click"):
		$"../AnimationPlayer".play_backwards("Focus")
	
	if event.is_action_pressed("left_click") and is_zoomed and can_shoot:
		$"../AnimationPlayer".play("Shoot")
		$"../ShootTimer".start()
		can_shoot = false

func _on_ShootTimer_timeout():
	can_shoot = true

func _ChargeTimer_start():
	$"../ChargeTimer".start()

func _on_ChargeTimer_timeout():
	var new_cannonball = CANNONBALL.instance()
	var new_cannonball2 = CANNONBALL.instance()
	var new_cannonball3 = CANNONBALL.instance()
	var new_cannonball4 = CANNONBALL.instance()
	
	cannon1.add_child(new_cannonball)
	cannon2.add_child(new_cannonball2)
	cannon3.add_child(new_cannonball3)
	cannon4.add_child(new_cannonball4)

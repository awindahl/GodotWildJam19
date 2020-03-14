extends KinematicBody

var velocity = Vector3()
var forward_speed = 50
var rotate_speed = 2

var camera_move_time = .5
var base_camera_flag = true
var no_buttons = true

onready var sail1 = $SailFront
onready var sail2 = $SailMid
onready var sail3 = $SailRear

func _ready():
	$Camera.transform = $CameraSail.transform

func _physics_process(delta):
	# Ship movement
	velocity = Vector3()
	if Input.is_action_pressed("ui_up"):
		velocity -= global_transform.basis.z * forward_speed
		
		# sail grows when moving forward
		if sail1.scale.z < 5:
			sail1.scale.z += 0.25
		if sail2.scale.z < 5:
			sail2.scale.z += 0.25
		if sail3.scale.z < 5:
			sail3.scale.z += 0.25
	
	if Input.is_action_pressed("ui_down"):
		velocity += global_transform.basis.z * forward_speed
	if Input.is_action_pressed("ui_right"):
		rotate(Vector3(0,1,0), -rotate_speed*delta)
	if Input.is_action_pressed("ui_left"):
		rotate(Vector3(0,1,0), rotate_speed*delta)
	
	# dirty way to see if we are pressing any directional keys
	if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		no_buttons = true
	else:
		no_buttons = false
	
	# if no keys are pressed, make the sails go down
	if no_buttons:
		if sail1.scale.z > 0.3:
			sail1.scale.z -= 0.2
		if sail2.scale.z > 0.3:
			sail2.scale.z -= 0.2
		if sail3.scale.z > 0.3:
			sail3.scale.z -= 0.2
		
	velocity = move_and_slide(velocity)
	
	# Camera controls
	if Input.is_action_just_pressed("ui_select"):
		#if $Camera.global_transform == $CameraSail.global_transform:
		if base_camera_flag:
			# Move camera to crew view
			#$Camera.transform.interpolate_with($CameraCrew.transform, camera_move_time)
			$Camera.transform = $CameraCrew.transform
		else:
			$Camera.transform = $CameraSail.transform
		base_camera_flag = !base_camera_flag

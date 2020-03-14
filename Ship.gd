extends KinematicBody

var velocity = Vector3()
var forward_speed = 50
var rotate_speed = 2

var camera_move_time = .5
var base_camera_flag = true

func _ready():
	$Camera.transform = $CameraSail.transform


func _physics_process(delta):
	# Ship movement
	velocity = Vector3()
	if Input.is_action_pressed("ui_up"):
		velocity -= global_transform.basis.z * forward_speed
	if Input.is_action_pressed("ui_down"):
		velocity += global_transform.basis.z * forward_speed
	if Input.is_action_pressed("ui_right"):
		rotate(Vector3(0,1,0), -rotate_speed*delta)
	if Input.is_action_pressed("ui_left"):
		rotate(Vector3(0,1,0), rotate_speed*delta)
	
	move_and_slide(velocity)
	
	# Camera controls
	if Input.is_action_just_pressed("ui_select"):
		print('select')
		print('Global: ', $Camera.transform)
		print('Sail: ', $CameraSail.transform)
		print('Crew: ', $CameraCrew.transform)
		#if $Camera.global_transform == $CameraSail.global_transform:
		if base_camera_flag:
			# Move camera to crew view
			#$Camera.transform.interpolate_with($CameraCrew.transform, camera_move_time)
			$Camera.transform = $CameraCrew.transform
		else:
			#$Camera.transform.interpolate_with($CameraSail.transform, camera_move_time)
			$Camera.transform = $CameraSail.transform
		base_camera_flag = !base_camera_flag

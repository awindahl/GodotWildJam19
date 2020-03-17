extends KinematicBody

export(float) var mouse_sensitivity = 1

var speed = 10
var my_rotation = Vector2()
var islands_in_range = 0


func _physics_process(delta):
	var dir = Vector3()

	var input_movement_vector = Vector3()

	if Input.is_action_pressed("ui_up"):
		input_movement_vector.z -= 1*speed
	if Input.is_action_pressed("ui_down"):
		input_movement_vector.z += 1*speed
	if Input.is_action_pressed("ui_left"):
		input_movement_vector.x -= 1*speed
	if Input.is_action_pressed("ui_right"):
		input_movement_vector.x += 1*speed
	
	move_and_slide(input_movement_vector, Vector3(0,1,0))



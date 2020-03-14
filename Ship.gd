extends KinematicBody

var velocity = Vector3()
var forward_speed = 50
var rotate_speed = 1

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
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

extends KinematicBody

const GRAVITY = -2
const TYPE = "CANNONBALL"
var speed = 4
var forward_dir

func _ready():
	
	forward_dir = get_parent().get_node("RayCast").get_global_transform().basis.x.normalized() * -1
	
func _process(delta):
	
	set_as_toplevel(true)
	forward_dir.y -= 0.001
	global_translate(forward_dir * delta * speed)

func _on_Area_body_entered(body):
	$MeshInstance.visible = false
	$Particles.emitting = true
	$KillTime.start()
	speed = 0

func _on_KillTime_timeout():
	queue_free()

func _on_TimeToLive_timeout():
	queue_free()

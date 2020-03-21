extends KinematicBody

const GRAVITY = -2
const TYPE = "CANNONBALL"
var speed = 4
var forward_dir

func _ready():
	
	forward_dir = get_parent().get_node("RayCast").get_global_transform().basis.x.normalized() * -1
	forward_dir.y = 0.01
	
func _process(delta):
	
	set_as_toplevel(true)
	forward_dir.y /= 1.1
	global_translate(forward_dir * delta * speed)

func _on_Area_body_entered(body):
	if not body.name == get_parent().get_parent().name and not body.name == get_parent().get_parent().get_parent().get_parent().name:
		$MeshInstance.visible = false
		$Particles.emitting = true
		$KillTime.start()
		speed = 0
		print(body.name)
		if body.name == "Player" or body.name == "Player2" or body.name == "Player3" or body.name == "Enemy":
			body.health -= 1
		else:
			pass

func _on_KillTime_timeout():
	queue_free()

func _on_TimeToLive_timeout():
	queue_free()

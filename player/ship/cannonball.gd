extends KinematicBody

const GRAVITY = -2
const TYPE = "CANNONBALL"
var speed = 4
var forward_dir
var sound_1 = preload("res://assets/sound/cannon/cannon hit 01.ogg")
var sound_2 = preload("res://assets/sound/cannon/cannon hit 02.ogg")
var sound_3 = preload("res://assets/sound/cannon/cannon hit 03.ogg")
var sound_4 = preload("res://assets/sound/cannon/cannon hit 04.ogg")

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
		
		var random = randi()%5+1
		
		match random:
			1:
				$AudioStreamPlayer3D.stream = sound_1
			2:
				$AudioStreamPlayer3D.stream = sound_2
			3:
				$AudioStreamPlayer3D.stream = sound_3
			4:
				$AudioStreamPlayer3D.stream = sound_4
		
		$AudioStreamPlayer3D.play()
		
		print(body.name)
		if body.name == "Player" or body.name == "Player2" or body.name == "Player3" or body.name == "Enemy":
			body.health -= 1
		else:
			pass

func _on_KillTime_timeout():
	queue_free()

func _on_TimeToLive_timeout():
	queue_free()

extends KinematicBody

const ACCELERATION = 0.1
const DECELERATION = 0.05
const TYPE = "ENEMY"
const CANNONBALL = preload("res://player/ship/cannonball.tscn")

export (NodePath) var patrol_path

onready var home = $Position3D
onready var area = $MeshInstance/Area
onready var ray = $RayCast
onready var cannon1 = $"Cannon"
onready var cannon2 = $"Cannon2"
onready var cannon3 = $"Cannon3"

var movement_speed = 0
var direction = Vector3()
var my_rotation = Vector2()
var movement = Vector3()
var is_turned = false
var target_rot = Vector3()
var look_pos = Vector3()
var patrol_points
var patrol_index = 0
var sees_player = false
var player_pos
var can_shoot = true
var health = 7
var is_dead = false

func _ready():

	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()

func _process(delta):
	
	patrol_points = get_node(patrol_path).curve.get_baked_points()

	if !patrol_path:
		return
	var patrol_target = patrol_points[patrol_index]
	if get_transform().origin.distance_to(patrol_target) < 1 and not sees_player and not is_dead:
		patrol_index = wrapi(patrol_index + 1, 0 , patrol_points.size())
		patrol_target = patrol_points[patrol_index]
		look_at(patrol_points[patrol_index], Vector3(0, 1, 0))

	elif not is_dead and sees_player:
		for body in area.get_overlapping_bodies():
			if body.TYPE == "PLAYER":
				if body.health <= 0:
					sees_player = false
				player_pos = body.get_transform().origin
				look_at(player_pos, Vector3(0, 1, 0))

	if not is_dead:
		rotation.x = 0
		movement.y -= 10 * delta

	if not sees_player:
		look_at(patrol_points[patrol_index], Vector3(0, 1, 0))
		rotation.x = 0
		movement = (patrol_target - get_transform().origin).normalized()
	elif sees_player:
		movement = (player_pos - get_transform().origin).normalized()

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

	if not is_dead:
		movement = move_and_slide(movement)

	if ray.is_colliding() and can_shoot and not is_dead:
		$AnimationPlayer.play("Shoot")

	if health == 0:
		is_dead = true
		$AnimationPlayer.play("Die")

func _on_Area_body_entered(body):
	if body.TYPE == "PLAYER":
		if body.health > 0:
			sees_player = true
		else:
			sees_player = false

func _on_Area_body_exited(body):
	if body.TYPE == "PLAYER":
		sees_player = false

func _on_ChargeTimer_timeout():
	$CooldownTimer.start()
	can_shoot = false
	var new_cannonball = CANNONBALL.instance()
	var new_cannonball2 = CANNONBALL.instance()
	var new_cannonball3 = CANNONBALL.instance()

	cannon1.add_child(new_cannonball)
	cannon2.add_child(new_cannonball2)
	cannon3.add_child(new_cannonball3)
	cannon1.get_node("Particles").emitting = true
	cannon2.get_node("Particles").emitting = true
	cannon3.get_node("Particles").emitting = true

func _on_AttackTimer_timeout():
	pass # Replace with function body.

func _on_CooldownTimer_timeout():
	can_shoot = true
	cannon1.get_node("Particles").emitting = false
	cannon2.get_node("Particles").emitting = false
	cannon2.get_node("Particles").emitting = false

func _free():
	queue_free()
	Global.player_gold += 300

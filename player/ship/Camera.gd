extends Spatial
 
const MOVE_MARGIN = 20
const MOVE_SPEED = 3
 
const ray_length = 1000
onready var cam = $CameraCrew
 
func _process(delta):
	var m_pos = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("main_command"):
		move_all_units(m_pos)
 
func move_all_units(m_pos):
	print('move all units')
	var result = raycast_from_mouse(m_pos, 7)
	if result:
		print('collision raycast detected, sending move to ', result.position)
		get_tree().call_group("crew", "move_to", result.position)
 
func raycast_from_mouse(m_pos, collision_mask):
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end = ray_start + cam.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)

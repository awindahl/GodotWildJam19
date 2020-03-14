extends WorldEnvironment

var fog_level = 0

func _ready():
	adjust_fog(fog_level)
	environment.dof_blur_far_enabled = true

func adjust_fog(lvl):
	if lvl == 2:
		environment.fog_enabled = false
	elif lvl == 1:
		environment.fog_enabled = true
		environment.fog_depth_begin = 10
		environment.fog_depth_end = 50
	else:
		environment.fog_enabled = true
		environment.fog_depth_begin = 5
		environment.fog_depth_end = 30

func cycle_fog():
	fog_level = (fog_level+1)%3
	adjust_fog(fog_level)
	print('fog ', fog_level)

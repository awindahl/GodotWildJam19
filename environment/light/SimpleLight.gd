extends OmniLight

export(float) var max_light := 1


func _ready():
	if !Global.day_time:
		light_energy = max_light
	else:
		light_energy = 0


func day_cycle_update(sun_rising, duration=1.0):
	$Tween.interpolate_property(self, "light_energy", light_energy, (1-int(sun_rising))*max_light, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

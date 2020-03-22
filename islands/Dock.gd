extends StaticBody

onready var area = $DockingArea

func _process(delta):
	
	for body in area.get_overlapping_bodies():
		if body.is_in_group("Player"):
			if body.get_node("Controller").movement.length() <= 0.2:
				pass

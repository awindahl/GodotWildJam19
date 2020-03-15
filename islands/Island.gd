tool
extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is MeshInstance:
			print('Name: ', child.name, ', #surfaces: ', child.get_surface_material_count())
			for idx in child.get_surface_material_count():
				print(idx)
				#var current_material = child.get_surface_material(idx)
				var current_material = child.mesh.surface_get_material(idx)
				current_material.distance_fade_mode = 1
				current_material.distance_fade_min_distance = 20
				current_material.distance_fade_max_distance = 10
				child.set_surface_material(idx, current_material)
			

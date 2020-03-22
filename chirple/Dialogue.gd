extends Spatial

func _process(delta):
	$"Control/letter/RichTextLabel".percent_visible += 0.01

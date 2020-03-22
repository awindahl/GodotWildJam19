extends Spatial

var string = Global.dialogue_string
var can_click = true
var my_str = ""
var start_dialogue = false
var end_dialogue = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	
	if start_dialogue:
		$"Control/letter/RichTextLabel".percent_visible += 0.01
		
	$"Control/letter/RichTextLabel".text = my_str
	
	match string:
		
		# intro 
		1:
			my_str = "Yarr me hearties! Are ye ready for the adventure of yer poor life?"
		2:
			my_str = "Aye, today we are searching for..."
		3:
			my_str = "DALTONGA!"
		4:
			my_str = "You will aid me on this here journey..."
		5:
			my_str = "Steer yer ship with yer mouse, hit W to go forward and S to hit the sea-brakes!"
		6:
			my_str = "Stop yer ship near an island to claim the islands relic, while yer here ye can repair yer ship!"
		7:
			my_str = "Ye need at least 4 relics to find Daltonga"
		8:
			my_str = "Watch out for pirates, they are after yer booty!"
		9:
			my_str = "Aim with the right mouse button, and fire with the left! And look at yer MAP with the 'm'-key."
		10:
			my_str = "Good luck me hearties!"
			end_dialogue = true

		## daltonga
		21:
			my_str = "Well done!"
		22:
			my_str = "It seems ye weren't no landlubber after all. Thank you for helping me find Daltonga."
		23:
			my_str = "Avast! Ye be free to roam the sees on yer own now. Hope ye learned something."
			end_dialogue = true
			
	if end_dialogue:
		$AnimationPlayer.play("Fly out")
	elif start_dialogue:
		$AnimationPlayer.play("Idle")
	

func _input(event):

	if Input.is_action_just_pressed("left_click") and start_dialogue and not end_dialogue:
		if can_click and $"Control/letter/RichTextLabel".percent_visible == 1:
			can_click = false
			string += 1
			$"Control/letter/RichTextLabel".percent_visible = 0
			$Timer.start()
		elif $"Control/letter/RichTextLabel".percent_visible < 1:
			$"Control/letter/RichTextLabel".percent_visible = 1
		
func _on_Timer_timeout():
	can_click = true

func _start_game():
	get_tree().change_scene("res://Main.tscn")

func _fly_in():
	string += 1
	start_dialogue = true
	$"Control/letter/RichTextLabel".percent_visible = 0

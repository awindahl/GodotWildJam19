extends Node

signal day_change

# Adjust these  -----------
var day_running = false # For pauses or stopping day/night cycle
var max_real_time = 180.0 # Real world day cycle time, put 10.0 to see fast day/night transition
var start_perc = .6  # Where to start in the day, percentage
var night_time_perc = .9  # Percentage of day to formally start NIGHT
var day_time_perc = .4  # Percentage of day to formally start DAY
# ---------------------

var timestep = 1.0/max_real_time  # Update each second
var current_time = start_perc * max_real_time
var day_time = ((current_time > day_time_perc) and (current_time < night_time_perc))

# player stuff
var player_gold = 0
var player_level = 1
var player_1_max_health = 10
var player_2_max_health = 15
var player_3_max_health = 20
var player_relics_found = 0
var dialogue_string = 0

func _ready():
	pass #current_time = start_perc * max_real_time

func _process(delta):
	if day_running:
		current_time += delta
		if current_time > max_real_time:
			current_time = 0.0
		#print(current_time)
		if day_time and (time_percentage() > night_time_perc):
			day_time = false
			day_update()
		elif !day_time and ((time_percentage() > day_time_perc) and (time_percentage() < night_time_perc)):
			day_time = true
			day_update()
	
	if Input.is_action_just_pressed("number_1"):
		OS.window_fullscreen = !OS.window_fullscreen

func day_update():
	get_tree().call_group("day_cycle_update","day_cycle_update", day_time, max(max_real_time*.05, 3))

func time_percentage():
	#print('% ', current_time/max_real_time)
	return current_time/max_real_time

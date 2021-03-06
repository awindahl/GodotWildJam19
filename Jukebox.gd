extends Node

onready var current = $Day/Intro

var change_of_random_fill = .25
var change_of_random_blank = .9
const consecutive_chance = 0.7

var next_fill = 0
var last_fill = 0

var track_type = "one_off"
var near_island = 0
var queue_track = []
# Needs day/night
# Needs one-off events (new land, near land, etc)
var switch_time = 9.29
var day_time = true

var player

func _ready():
	randomize()
	$SwitchTimer.wait_time = .5
	$SwitchTimer.start()
	print('Playing intro ', current.get_path())
	queue_track.append(current)
	


func _on_track_finished():
	pass

func next_song():
	if queue_track.size() > 0:
		current = queue_track[0]
		queue_track.remove(0)
	else:
		if near_island > 0:
			current = $NearLand
		else:
			var up_next = []
			if (randf() < change_of_random_fill): # and (near_island>0)
				track_type = 'fill'
				up_next = $Day/Fill.get_children()
				while next_fill == last_fill:
					next_fill = randi() % up_next.size()
				current = up_next[next_fill]
				last_fill = next_fill
			elif (track_type == "one_off") or (randf() < change_of_random_blank):
				up_next = $Day/Blank.get_children()
				if (track_type == 'blank') and randf() > consecutive_chance:
					current = up_next[randi() % up_next.size()]
				else:
					current = up_next[randi() % up_next.size()]
				track_type = 'blank'
			else:
				up_next = [current]
				current = up_next[randi() % up_next.size()]
	
	print('Now playing track ' + current.get_path(), '; Queue: ', queue_track)
	
	if player == $Player1:
		player = $Player0
	else:
		player = $Player1
	player.stream = current.get_stream()
	player.play()
	
	
	
	#current.play()
	
	# Update timer
	#print(current.stream.get_length())
	$SwitchTimer.wait_time = player.stream.get_length() - (.71 + .838708)
	$SwitchTimer.start()

func update_near_island(amount):
	if (near_island == 0) and (amount == 1) and (current != $FindingLand) and !($FindingLand in queue_track):
		queue_track.append($FindingLand)
	elif (near_island > 0) and (amount == -1) and (current != $LeavingLand) and !($LeavingLand in queue_track):
		queue_track.append($LeavingLand)
	near_island = max(0, near_island + amount)
	#print('Near island: ', near_island)

func dock_on_port():
	print('Docking!')
	#if !($FindingLand in queue_track):
	#	queue_track.append($NearLand)
	
func leave_port():
	print('Leaving dock!')
	#if !($LeavingLand in queue_track):
	#	queue_track.append($LeavingLand)

func _on_SwitchTimer_timeout():
	next_song()

func switch_to_night():
	queue_track.append($Night/Intro)

func switch_to_day():
	queue_track.append($Day/Intro)

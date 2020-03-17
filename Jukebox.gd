extends Node

onready var current = $Day/Intro

var change_of_random_fill = .5
var change_of_random_blank = .9

var track_type = "one_off"
var near_island = 0
var queue_track = []
# Needs day/night
# Needs one-off events (new land, near land, etc)

func _ready():
	randomize()
	print('Playing intro ', current.get_path())
	current.play()

func _on_track_finished():
	if queue_track.size() > 0:
		current = queue_track[0]
		queue_track.remove(0)
	else:
		var up_next = []
		if (near_island>0) and (randf() < change_of_random_fill):
			track_type = 'fill'
			up_next = $Day/Fill.get_children()
		elif (track_type == "one_off") or (randf() < change_of_random_blank):
			track_type = 'blank'
			up_next = $Day/Blank.get_children()
		else:
			up_next = [current]
		current = up_next[randi() % up_next.size()]
	
	print('Now playing track ' + current.get_path(), '; Queue: ', queue_track)
	current.play()

func update_near_island(amount):
	if (near_island == 0) and (amount == 1) and (current != $NearLand) and !($NearLand in queue_track):
		queue_track.append($NearLand)
	near_island = max(0, near_island + amount)
	print('Near island: ', near_island)

func dock_on_port():
	print('Docking!')
	if !($FindingLand in queue_track):
		queue_track.append($FindingLand)
	
func leave_port():
	print('Leaving!')
	if !($LeavingLand in queue_track):
		queue_track.append($LeavingLand)

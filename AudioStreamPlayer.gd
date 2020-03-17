extends AudioStreamPlayer

onready var day_intro = load("res://assets/music/day/Day Intro.ogg")

onready var blank1 = load("res://assets/music/day/Day Blank 1.ogg")
onready var blank2 = load("res://assets/music/day/Day Blank 2.ogg")
onready var blank3 = load("res://assets/music/day/Day Blank 3.ogg")

onready var fill1 = load("res://assets/music/day/Day Fill-001.ogg")
onready var fill2 = load("res://assets/music/day/Day Fill-002.ogg")
onready var fill3 = load("res://assets/music/day/Day Fill-003.ogg")


var blanks = [blank1, blank2, blank3]
var fills = [fill1, fill2, fill3]

var islands_in_range = 0
var current = day_intro

func _ready():
	play(day_intro)


func _on_Jukebox_finished():
	print('Now playing day intro')
	play(day_intro)

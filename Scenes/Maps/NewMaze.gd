extends Node3D


@onready var win_panel = $"UI/WinScreen"
@onready var lose_panel = $"UI/LossScreen"
@onready var win_time = $"UI/WinScreen/VBoxContainer/TimeRemaining"


@onready var orb_label = $"UI/OrbsLeft"
@onready var timer_label = $"UI/Timer"
@export var starting_orbs := 170
@export var starting_time := 120.0


var orbs_left := 170
var time_left := 0.0
var game_over := false


func _ready():
	orbs_left = starting_orbs
	time_left = starting_time
	update_ui()


func _process(delta):
	if game_over:
		return
	
		time_left -= delta
		if time_left <= 0:
			time_left = 0
			lose_game()
	
		update_ui()


func orb_collected():
	if game_over:
		return

	orbs_left -= 1

	if orbs_left <= 0:
		win_game()

	update_ui()


func update_ui():
	orb_label.text = "Orbs Left: %d" % orbs_left

	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60

	timer_label.text = "%02d:%02d" % [minutes, seconds]


func win_game():
	game_over = true

	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60

	win_time.text = "Time Remaining: %02d:%02d" % [minutes, seconds]

	win_panel.visible = true

	get_tree().paused = true


func lose_game():
	game_over = true

	lose_panel.visible = true

	get_tree().paused = true

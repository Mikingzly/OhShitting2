extends Node3D

@onready var post_process = $PostProcess
@onready var player = $"Player"
@onready var win_panel = $"UI/WinScreen"
@onready var lose_panel = $"UI/LossScreen"
@onready var win_time = $"UI/WinScreen/VBoxContainer/TimeRemaining"
@onready var orb_label = $"UI/OrbsLeft"
@onready var timer_label = $"UI/Timer"
@onready var tick_audio = $"TickSound"
@onready var win_audio = $"UI/WinSound"
@onready var lose_audio = $"UI/LoseSound"

@export var starting_orbs := 170
@export var starting_time := 90.0

var base_speed := 5.0
var player_speed := 5.0
var inverted_controls := false
var orbs_left := 170
var time_left := 0.0
var game_over := false
var last_second := -1

func _ready():
	apply_modifier(GameState.current_modifier)
	print("Timer Ready")
	orbs_left = starting_orbs
	time_left = starting_time
	update_ui()


func _process(delta):
	print(time_left)

	if game_over:
		return

	time_left -= delta

	if time_left <= 0:
		time_left = 0
		lose_game()

	var current_second = int(time_left)

	if current_second != last_second:
		last_second = current_second

		if current_second < int(starting_time):
			tick_audio.pitch_scale = lerp(1.0, 1.5, 1.0 - (time_left / starting_time))
			tick_audio.play()


	update_ui()


func disable_shaders():
	post_process.visible = false


func apply_modifier(mod: String) -> void:
	match mod:
		"Standard":
			apply_standard()

		"Gotta Go Swifter":
			apply_swifter()

		"Cut Short":
			apply_cut_short()

		"Inverted World":
			apply_inverted()

		"Forever Dark":
			apply_dark()

		"ShaderPocolypse":
			apply_shaders()

		"Detective style":
			apply_monochrome()

		"Disaster Fest":
			apply_disaster_fest()

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

	var total_ms = int(time_left * 1000)

	var minutes = total_ms / 60000
	var seconds = (total_ms / 1000) % 60
	var milliseconds = (total_ms % 1000) / 10  # 2-digit ms
	var ratio = clamp(time_left / starting_time, 0.0, 1.0)
	var red = Color(1, 0.2, 0.2)
	var normal = Color(1, 1, 1)

	if time_left < 10.0:
		var flash = sin(Time.get_ticks_msec() * 0.01) * 0.5 + 0.5
		timer_label.modulate = Color(1, flash, flash)
	else:
		timer_label.modulate = Color(1, 1, 1)

	timer_label.add_theme_color_override(
	"font_color",
	normal.lerp(red, 1.0 - ratio)
)
	timer_label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	#print("Updating UI:", time_left)
	#orb_label.text = "Orbs Left: %d" % orbs_left

	#var minutes = int(time_left) / 60
	#var seconds = int(time_left) % 60

	#timer_label.text = "%02d:%02d" % [minutes, seconds]


func win_game():
	game_over = true

	win_audio.play()

	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60

	win_time.text = "Time Remaining: %02d:%02d" % [minutes, seconds]

	win_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true


func lose_game():
	game_over = true

	lose_audio.play()

	lose_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true


func apply_standard():
	player_speed = base_speed
	time_left = starting_time
	inverted_controls = false

	player.set_speed(player_speed)
	player.set_inverted(false)

func apply_swifter():
	player_speed = base_speed * 2.0
	player.set_speed(player_speed)


func apply_cut_short():
	time_left = 60.0
	starting_time = 60.0


func apply_inverted():
	inverted_controls = true
	player.set_inverted(true)


func apply_dark():
	player.set_flashlight(false)


func apply_shaders():
	post_process.visible = true


func apply_monochrome():
	var env = $WorldEnvironment.environment

	env.adjustment_enabled = true
	env.adjustment_saturation = 0.0
	env.adjustment_contrast = 1.2
	env.adjustment_brightness = -0.05


func apply_disaster_fest():
	apply_swifter()
	apply_cut_short()
	apply_inverted()
	apply_dark()
	apply_shaders()
	apply_monochrome()

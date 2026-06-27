extends Control

@onready var wheel = $Textures/Wheel
@onready var result_label = $ResultLabel
@onready var spin_button = $Textures/btn_spin
@onready var continue_button = $ContinueButton

@onready var labels_container = $Textures/Wheel/Labels
@onready var labels := []

const SLICES := 8
const SLICE_ANGLE := 360.0 / SLICES

var spinning := false
var has_result := false
var result_index := -1


func _process(_delta):
	for i in range(labels.size()):
		var label = labels[i]
		
		var angle_offset = wheel.rotation_degrees
		
		var base_angle = i * SLICE_ANGLE - 90
		var angle = deg_to_rad(base_angle + angle_offset)
		
		var radius = wheel.size.x * 0.38
		var center = wheel.size / 2
		
		label.position = center + Vector2(cos(angle), sin(angle)) * radius - label.size / 2
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.size = Vector2(120, 30) # or whatever fits your design
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_constant_override("outline_size", 2)


func _ready():
	wheel.pivot_offset = wheel.size / 2

	labels = labels_container.get_children()
	await get_tree().process_frame
	position_labels()

	result_label.text = ""
	continue_button.visible = false


var modifiers := [
	"Standard",
	"Gotta Go Swifter",
	"Cut Short",
	"Inverted World",
	"Forever Dark",
	"Shaderpocolypse",
	"Detective style",
	"Disaster Fest"
]


func position_labels():
	var center = wheel.size / 2
	var radius = wheel.size.x * 0.38
	
	for i in range(SLICES):
		var label = labels[i]
		
		label.text = modifiers[i]
		
		var angle_deg = i * SLICE_ANGLE - 90
		var angle = deg_to_rad(angle_deg)
		
		var pos = Vector2(cos(angle), sin(angle)) * radius
		
		# IMPORTANT: local positioning inside wheel space
		label.position = center + pos - (label.size / 2)


func apply_modifier(index: int) -> void:
	GameState.current_modifier = modifiers[index]


func spin_wheel():
	if spinning or has_result:
		return
	
	spinning = true
	spin_button.disabled = true

	# pick random slice
	var result_index = randi() % SLICES

	# how many full spins
	var full_spins = 5

	# target angle so chosen slice lands at top (0 degrees)
	var target_angle = (full_spins * 360.0) + (result_index * SLICE_ANGLE)

	# tween rotation
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(wheel, "rotation_degrees", target_angle, 3.0)

	tween.finished.connect(func():
		spinning = false
		has_result = true
		apply_modifier(result_index)
		
		show_result(result_index)
		show_continue_button()
	)

func show_result(index: int) -> void:
	var text := ""

	match index:
		0: text = "Standard"
		1: text = "Gotta Go Swifter"
		2: text = "Cut Short"
		3: text = "Invert World"
		4: text = "Forever Dark"
		5: text = "Shaderpocolypse"
		6: text = "Detective Style"
		7: text = "Disaster Fest"

	result_label.text = text


func show_continue_button():
	spin_button.visible = false
	continue_button.visible = true







func _on_btn_spin_pressed() -> void:
	spin_wheel()


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Maps/NewMazeTest.tscn")

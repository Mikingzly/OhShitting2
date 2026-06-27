extends Control

@onready var music = $MenuMusic

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/WheelSpin.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _ready():
	if not music.playing:
		music.play()

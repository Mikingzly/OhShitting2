extends Area3D

@onready var audio = $AudioStreamPlayer3D
@export var collect_sounds: Array[AudioStream]
var last_sound := -1


@export var points := 1
var t := 0.0
var start_pos : Vector3

func _ready():
	start_pos = position
	body_entered.connect(_on_body_entered)
	randomize()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		Game.add_score(points)
		audio.stream = collect_sounds[randi() % collect_sounds.size()]
		audio.play()
		get_node("/root/NewMazeTest").orb_collected()
		print("Touched by:", body.name)
		await audio.finished
		queue_free()


func _process(delta):
	t += delta
	position.y = start_pos.y + sin(t * 3.0) * 0.1
	
	
func play_random_sound():
	var index = randi() % collect_sounds.size()

	while collect_sounds.size() > 1 and index == last_sound:
		index = randi() % collect_sounds.size()

	last_sound = index
	audio.stream = collect_sounds[index]
	audio.play()

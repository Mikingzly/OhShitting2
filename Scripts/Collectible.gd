extends Area3D

@export var points := 1
var t := 0.0
var start_pos : Vector3

func _ready():
	start_pos = position
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		Game.add_score(points)
		Game.play_pickup()
		print("Touched by:", body.name)
		queue_free()


func _process(delta):
	t += delta
	position.y = start_pos.y + sin(t * 3.0) * 0.1

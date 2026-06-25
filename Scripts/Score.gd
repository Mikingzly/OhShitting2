extends Label


func _process(_delta):
	text = "Score: %d" % Game.score

extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(speed * delta)
<<<<<<< HEAD
@export var speed:float = 0.5
=======
@export var speed:float = 2
 
>>>>>>> ab93cd5293ff58b8d7eec1ea9f913a5645db89a5

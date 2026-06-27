extends Node

var current_modifier: String = "Standard"
var score := 0

func add_score(amount):
	score += amount

func reset_score():
	score = 0

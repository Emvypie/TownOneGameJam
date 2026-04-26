extends Node

@onready var label = $Label

var score = 0

func _ready():
	update_score()

func add_score():
	score += 1
	update_score()

func update_score():
	label.text = "Score: " + str(score)

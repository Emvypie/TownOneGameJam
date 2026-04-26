extends Node

@export var score_label: Label
@export var split30_label: Label
@export var split60_label: Label
@export var peak_rate_label: Label

var score = 0
var time_passed = 0.0

var split_30_done = false
var split_60_done = false

var peak_rate = 0.0
var previous_check_score = 0
var next_rate_check = 10.0
var peak_shown = false

func _ready():
	score_label.text = "Score: 0"
	split30_label.text = "30s: "
	split60_label.text = "1m: "
	peak_rate_label.text = "Peak Rate: "

func _process(delta):
	time_passed += delta

	if Input.is_action_just_pressed("CRANK"):
		add_score()

	if time_passed >= 30.0 and !split_30_done:
		split30_label.text = "30s: " + str(score)
		split_30_done = true

	if time_passed >= 60.0 and !split_60_done:
		split60_label.text = "1m: " + str(score)
		split_60_done = true

	if time_passed >= next_rate_check and next_rate_check <= 90.0:
		var gained_score = score - previous_check_score
		var current_rate = gained_score / 10.0

		if current_rate > peak_rate:
			peak_rate = current_rate

		previous_check_score = score
		next_rate_check += 10.0

	if time_passed >= 90.0 and !peak_shown:
		peak_rate_label.text = "Peak Rate: " + str(snapped(peak_rate, 0.01))
		peak_shown = true

func add_score():
	score += 1
	score_label.text = "Score: " + str(score)

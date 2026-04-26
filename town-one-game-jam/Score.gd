extends Node

@export var score_label: Label
@export var split30_label: Label

var score = 0
var time_passed = 0.0

var split_30_done = false
var stop_incrementing = false

var peak_rate = 0.0
var previous_check_score = 0
var next_rate_check = 10.0
var peak_shown = false
var frankenstein = null
var final_score = null
var game_over = null

func _ready():
	score_label.text = "Score: 0"
	split30_label.text = "30s: "

func _process(delta):
	time_passed += delta
	var timer = $"../Timer/Timer"
	timer.timeout.connect(set_final_score)

	if time_passed >= 30.0 and !split_30_done:
		split30_label.text = "30s: " + str(score)
		split_30_done = true

	if time_passed >= next_rate_check and next_rate_check <= 60.0:
		var gained_score = score - previous_check_score
		var current_rate = gained_score / 10.0

		if current_rate > peak_rate:
			peak_rate = current_rate

		previous_check_score = score
		next_rate_check += 10.0

func _input(event):
	if time_passed < 60.0:
		frankenstein = $"../Frankenstein/AnimationPlayer"
		if event.is_action_pressed("PLAYER_B_BTN_2"):
			frankenstein.play("Right punch")
			add_score()
			play_punch_sound()

		if event.is_action_pressed("PLAYER_B_BTN_1"):
			frankenstein.play("Left punch")
			add_score()
			play_punch_sound()


func add_score():
	if time_passed < 60.0:
		score += 1
		score_label.text = "Score: " + str(score)

func play_punch_sound():
	var punch_sound = $"../Frankenstein/Punch"
	punch_sound.play()

func set_final_score():
	final_score = $"../GameOverScene/FinalScore"
	final_score.text = "Score: " + str(score)
	final_score = $"../GameOverScene/PeakRate"
	final_score.text = "Peak Rate: " + str(peak_rate)

	return score

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
var right_beam = null
var left_beam = null
var right_fire = null
var left_fire = null
var beam_timer = 0
var fire_timer = 0
var total_time = 64.0
var time_to_reset = 2.0
var reset_timer = 0

func _ready():
	score_label.text = "0"
	split30_label.text = "30s: "

func _process(delta):
	time_passed += delta
	var timer = $"../Timer/Timer"
	timer.timeout.connect(set_final_score)

	if time_passed >= 30.0 and !split_30_done:
		split30_label.text = "30s: " + str(score)
		split_30_done = true

	if time_passed >= next_rate_check and next_rate_check <= total_time:
		var gained_score = score - previous_check_score
		var current_rate = gained_score / 10.0

		if current_rate > peak_rate:
			peak_rate = current_rate

		previous_check_score = score
		next_rate_check += 10.0

func _input(event):
	if event.is_action_pressed("RESTART"):
		reset_timer = get_tree().create_timer(0.05)
		reset_timer.timeout.connect(_reset_game)
		
	if time_passed < total_time:
		frankenstein = $"../Frankenstein/AnimationPlayer"
		right_beam = $"../Frankenstein/RightTrack_GPUParticles3D3"
		left_beam = $"../Frankenstein/LeftTrack_GPUParticles3D2"
		right_fire = $"../Frankenstein/RightFire_GPUParticles3D2"
		left_fire = $"../Frankenstein/LeftFire_GPUParticles3D"

		if event.is_action_pressed("PLAYER_B_BTN_2"):
			# show right beam
			right_beam.visible = true
			right_fire.visible = true
			beam_timer = get_tree().create_timer(0.05)
			beam_timer.timeout.connect(_beam_timer_timeout.bind(right_beam))
			fire_timer = get_tree().create_timer(0.2)
			fire_timer.timeout.connect(_fire_timer_timeout.bind(right_fire))

			# punch/sound
			frankenstein.play("Right punch")
			add_score()
			play_punch_sound()

		if event.is_action_pressed("PLAYER_B_BTN_1"):
			# show left beam
			left_beam.visible = true
			left_fire.visible = true
			beam_timer = get_tree().create_timer(0.05)
			beam_timer.timeout.connect(_beam_timer_timeout.bind(left_beam))
			fire_timer = get_tree().create_timer(0.2)
			fire_timer.timeout.connect(_fire_timer_timeout.bind(left_fire))

			# punch/sound
			frankenstein.play("Left punch")
			add_score()
			play_punch_sound()

func _beam_timer_timeout(beam) -> void:
	beam.visible = false

func _fire_timer_timeout(fire) -> void:
	fire.visible = false

func _reset_game() -> void:
	get_tree().reload_current_scene()

func add_score():
	if time_passed < total_time:
		score += 1
		score_label.text = str(score)

func play_punch_sound():
	var punch_sound = $"../Frankenstein/Punch"
	punch_sound.play()

func set_final_score():
	final_score = $"../GameOverScene/FinalScore"
	final_score.text = "Score: " + str(score)
	final_score = $"../GameOverScene/PeakRate"
	final_score.text = "Peak Rate: " + str(peak_rate)

	return score

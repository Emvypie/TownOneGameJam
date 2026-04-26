extends Node


@onready var label = $Label
@onready var timer = $Timer

func _ready():
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func time_left():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

func _process(delta):
	label.text = "%02d:%02d" % time_left()

func _on_timer_timeout():
	#get_tree().change_scene_to_file("res://GameOver_Scene.tscn")
	$"../GameOverScene".visible = true

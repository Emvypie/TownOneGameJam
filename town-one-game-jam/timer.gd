extends Node

@onready var label = $Label
@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	start_countdown()

func start_countdown() -> void:
	for i in range(3, 0, -1):
		label.text = str(i)
		await get_tree().create_timer(1.0).timeout
	
	label.text = "GO!"
	await get_tree().create_timer(1).timeout
	
	timer.start()

func time_left():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

func _process(delta):
	if timer.time_left > 0:
		label.text = "%02d:%02d" % time_left()

func _on_timer_timeout():
	$"../GameOverScene".visible = true

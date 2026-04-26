extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("PLAYER_B_BTN_2"):
		$AnimationPlayer.play("Right punch")
		
	if event.is_action_pressed("PLAYER_B_BTN_1"):
		$AnimationPlayer.play("Left punch")

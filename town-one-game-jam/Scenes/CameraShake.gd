extends Camera3D

var is_shaking := false
var can_input = false

func shake_rotation(max_rotation_degrees: float, duration: float) -> void:
	if is_shaking:
		return
	
	is_shaking = true
	
	var time_left := duration
	var start_rotation := rotation
	var max_rotation := deg_to_rad(max_rotation_degrees)
	
	while time_left > 0:
		var offset_x = randf_range(-max_rotation, max_rotation)
		var offset_y = randf_range(-max_rotation, max_rotation)
		
		rotation.x = start_rotation.x + offset_x
		rotation.y = start_rotation.y + offset_y
		
		time_left -= get_process_delta_time()
		await get_tree().process_frame
		
		start_rotation.x = rotation.x - offset_x
	
	rotation = start_rotation
	is_shaking = false

func _ready():
	await get_tree().create_timer(3.5).timeout
	can_input = true

func _input(event):
	if can_input:
		if event.is_action_pressed("PLAYER_B_BTN_2"):
			shake_rotation(3, 0.1)
		if event.is_action_pressed("PLAYER_B_BTN_1"):
			shake_rotation(3, 0.1)

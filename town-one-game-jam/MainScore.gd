extends Label

@export var score_source_path: NodePath

@export var property_name: String = "score"

# Colors set in Inspector

@export var color_green: Color = Color(0.2, 1.0, 0.2)

@export var color_blue: Color = Color(0.2, 0.5, 1.0)

@export var color_purple: Color = Color(0.7, 0.2, 1.0)

@export var color_red: Color = Color(1.0, 0.1, 0.1)

# Scale shake settings

@export var shake_strength: float = 4.0

@export var shake_time: float = 0.18

var score_source: Node

var base_scale: Vector2

var current_tier := 0

var shaking := false

var shake_timer := 0.0

func _ready():

	base_scale = scale
	if score_source_path != NodePath():
		score_source = get_node(score_source_path)
	else:
		score_source = get_parent()

func _process(delta):

	if score_source == null:
		return
	var score = int(score_source.get(property_name))
	update_color(score)
	update_scale(score)
	update_shake(delta)

func update_color(score: int):

	var final_color: Color
	if score <= 350:
		var t = float(score) / 350.0
		final_color = color_green.lerp(color_blue, t)
	elif score <= 550:
		var t = float(score - 350) / 200.0
		final_color = color_blue.lerp(color_purple, t)
	else:
		var capped = min(score, 1000)
		var t = float(capped - 550) / 450.0
		final_color = color_purple.lerp(color_red, t)
	add_theme_color_override("font_color", final_color)

func update_scale(score: int):

	var target_scale = base_scale
	var new_tier = 0
	if score >= 600:
		target_scale = base_scale * 1.5
		new_tier = 2
	elif score >= 350:
		target_scale = base_scale * 1.2
		new_tier = 1
	scale = scale.lerp(target_scale, 10.0 * get_process_delta_time())
	if new_tier != current_tier:
		current_tier = new_tier
		start_shake()

func start_shake():

	shaking = true
	shake_timer = shake_time

func update_shake(delta):

	if shaking:
		shake_timer -= delta
		var offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		position = offset
		if shake_timer <= 0:
			shaking = false
			position = Vector2.ZERO

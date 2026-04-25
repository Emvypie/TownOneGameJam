class_name Jump
extends Resource

@export_group("Jump")
@export var jump_speed: float = 2250.0

@export_group("Super Jump")
@export var super_jump_h: float = 650.0
@export var super_jump_speed: float = 2250.0
@export var enable_super_jump: bool = true


func jump(player: CharacterBody2D, s: Dictionary) -> void:
	# Vertical launch only (Celeste style)
	player.velocity.y = -jump_speed

	# Arm gravity windows
	s["hold_timer"] = float(s.get("hold_window", 0.08))
	s["cut_timer"] = float(s.get("cut_window", 0.14))


func super_jump(player: CharacterBody2D, s: Dictionary, facing: int) -> void:
	if not enable_super_jump:
		jump(player, s)
		return

	# Set horizontal magnitude based on facing
	player.velocity.x = super_jump_h * facing

	# Vertical launch
	player.velocity.y = -super_jump_speed

	# Arm gravity windows
	s["hold_timer"] = float(s.get("hold_window", 0.08))
	s["cut_timer"] = float(s.get("cut_window", 0.14))

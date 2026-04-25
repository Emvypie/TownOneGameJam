extends CharacterBody2D

signal on_grounded_changed(is_grounded: bool)
signal dash_started(dir: Vector2)
signal visual_state_changed(state: int)

enum VisualState {
	BASE,
	DASH,
	HURT,
	PARRY,
}

@export_group("Movement")
@export var jump: Jump = null

@export_group("Forgiveness")
@export var coyote_time: float = 0.10
@export var jump_buffer_time: float = 0.10

@export_group("Dash Jump")
@export var dash_jump_window: float = 0.10 # window where a buffered jump becomes a super jump after dash start

@export_group("Corner Policy")
@export var prefer_wall_jump_on_corner: bool = false # default false = normal jump wins

# --- Celeste-style authority state ---
var s: Dictionary = {
	# input
	"raw_axis_x": 0.0,
	"move_x": 0,                  # -1/0/+1
	"effective_move_x": 0,        # forced or raw
	"aim": Vector2.ZERO,          # for dash direction
	"facing": 1,                  # -1/+1

	# jump input
	"jump_held": false,

	# grounded flags
	"is_grounded": false,
	"was_grounded": false,

	# wall
	"wall_normal": Vector2.ZERO,

	# dash availability (authority)
	"dash_available": true,

	# gravity/jump windows (owned by Gravity; armed by Jump)
	"hold_window": 0.08,
	"cut_window": 0.14,
	"hold_timer": 0.0,
	"cut_timer": 0.0,

	# forced horizontal control (wall jump)
	"force_move_x": 0,
	"force_move_x_timer": 0.0,

	# wall timers (authority)
	"wall_regrab_timer": 0.0,
	"wall_contact_timer": 0.0,

	# push state mirror (Push owns internal timers; Player owns starting)
	"is_pushing": false,
}

# timers (authority)
var jump_buffer_timer: float = 0.0
var jump_grace_timer: float = 0.0
var dash_jump_timer: float = 0.0

var dash_visual_active: bool = false


func _ready() -> void:
	s["is_grounded"] = is_on_floor()
	s["was_grounded"] = s["is_grounded"]



	visual_state_changed.emit(VisualState.BASE)


func _physics_process(delta: float) -> void:
	# dash visual ends when dash state ends

	_read_input()
	_tick_timers(delta)


	# ========================
	# PUSH override (below dash)
	# ========================




# -----------------
# Authority helpers
# -----------------

func _read_input() -> void:
	var axis_x: float = float(Input.get_axis("LEFT", "RIGHT"))
	s["raw_axis_x"] = axis_x

	# Celeste-style digital moveX
	var mx: int = 0
	if axis_x > 0.0:
		mx = 1
	elif axis_x < 0.0:
		mx = -1
	s["move_x"] = mx

	if mx != 0:
		s["facing"] = mx

	# aim for dash direction selection (does not affect run speed)
	s["aim"] = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")

	s["jump_held"] = Input.is_action_pressed("JUMP")


func _tick_timers(delta: float) -> void:
	# jump buffer
	if Input.is_action_just_pressed("JUMP"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)

	# jump grace (coyote)
	if is_on_floor():
		jump_grace_timer = coyote_time
	else:
		jump_grace_timer = maxf(jump_grace_timer - delta, 0.0)

	# dash-jump window
	dash_jump_timer = maxf(dash_jump_timer - delta, 0.0)

	# forced horizontal control (walljump)
	var ft: float = float(s.get("force_move_x_timer", 0.0))
	if ft > 0.0:
		ft = maxf(ft - delta, 0.0)
		s["force_move_x_timer"] = ft

	# wall regrab timer
	var wr: float = float(s.get("wall_regrab_timer", 0.0))
	if wr > 0.0:
		s["wall_regrab_timer"] = maxf(wr - delta, 0.0)

	# compute effectiveMoveX (forced overrides)
	var force_t: float = float(s.get("force_move_x_timer", 0.0))
	if force_t > 0.0:
		s["effective_move_x"] = int(s.get("force_move_x", 0))
	else:
		s["effective_move_x"] = int(s.get("move_x", 0))


func _tick_wall_contact(delta: float) -> void:
	# tiny wall contact memory so walljump doesn’t miss on 1-frame detach
	var wct: float = float(s.get("wall_contact_timer", 0.0))
	if is_on_wall():
		s["wall_contact_timer"] = 0.08
	else:
		s["wall_contact_timer"] = maxf(wct - delta, 0.0)







	# consume jump buffer/grace so push doesn’t accidentally eat a buffered jump
	jump_buffer_timer = 0.0
	jump_grace_timer = 0.0




func _try_resolve_jump() -> void:
	if jump_buffer_timer <= 0.0:
		return





	# never wall jump if grounded (Celeste)


	# prevent instant regrab





	# consume jump buffer/grace
	jump_buffer_timer = 0.0
	jump_grace_timer = 0.0

	

	# Apply wall jump (executor)

	# Dash becomes available after wall jump (Celeste-ish)
	s["dash_available"] = true


# -----------------
# Movement plumbing
# -----------------




func _cache_wall_normal() -> void:
	var best: Vector2 = Vector2.ZERO
	var count: int = get_slide_collision_count()
	for i in range(count):
		var c := get_slide_collision(i)
		if c == null:
			continue
		var n: Vector2 = c.get_normal()
		if absf(n.x) > 0.6:
			best = n
			break
	s["wall_normal"] = best


func _post_grounded() -> void:
	s["was_grounded"] = s["is_grounded"]
	s["is_grounded"] = is_on_floor()

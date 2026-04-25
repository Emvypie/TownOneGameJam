extends CharacterBody3D

## -----------------------------------------------------------------------------
## Enums
## -----------------------------------------------------------------------------

enum EStates {
	IDLE,
	WALK,
	PICKUP,
	PUTDOWN,
	CHOP
}

signal on_current_state_changed(state: EStates)

var initial_state: EStates = EStates.IDLE

var _current_state: EStates = EStates.IDLE
var current_state: EStates:
	get:
		return _current_state
	set(value):
		if _current_state != value:
			_current_state = value
			on_current_state_changed.emit(value)
@onready var hold_position = $"."
var picked_object = null

## -----------------------------------------------------------------------------
## Export Variables
## -----------------------------------------------------------------------------

@export_group("3D")
@export var rotation_speed: float = 10.0
@export var camera_pivot: Node3D
@export var speed = 10
var move_input: Vector2 = Vector2.ZERO

func _ready() -> void:
	current_state = initial_state
	
func _physics_process(delta: float) -> void:
	move_input = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")

	match current_state:
		EStates.IDLE:
			idle(delta)
		EStates.WALK:
			walk(delta)
		EStates.PICKUP:
			pickup()

	get_input()
	
func _input(event):
	if event.is_action_pressed("PICKUP"):
		pickup()
	if event.is_action_pressed("PUTDOWN"):
		putdown()
		
## State Code

func idle(delta: float) -> void:
	velocity = Vector3.ZERO
	
	if move_input != Vector2.ZERO:
		current_state = EStates.WALK
		
func walk(delta: float) -> void:
	
	var direction = Vector3.ZERO
	var vertical_movement = Input.get_axis("DOWN", "UP")
	var horizontal_movement = Input.get_axis("LEFT", "RIGHT")
	
	direction.x += horizontal_movement
	direction.z += vertical_movement

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Ground Velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Moving the Character
	move_and_slide()

	if move_input == Vector2.ZERO:
		current_state = EStates.IDLE

## Action Code

		
func pickup() -> void:
	print("pickup")
	picked_object = $"../Environment/StaticBody3D"
	picked_object.reparent(hold_position)
	print(picked_object)

			
func putdown() -> void:
	if picked_object != null:
		# Re-enable physics and return to world
		picked_object.reparent(get_tree().root) # Or your world node
		picked_object = null

## Helper Functions

func is_in_range() -> bool:
	var range_radius = 10
	if position.distance_to(position) < range_radius:
		return true
	return false


## Movement Code
var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("LEFT", "RIGHT")

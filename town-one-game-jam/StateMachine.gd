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
			pickup(delta)
		EStates.PUTDOWN:
			putdown(delta)
		EStates.CHOP:
			chop(delta)

	get_input()

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
		# Setting the basis property will affect the rotation of the node.
		
		# ROTATION
		#$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Moving the Character
	move_and_slide()

	if move_input == Vector2.ZERO:
		current_state = EStates.IDLE

## Action Code

func pickup(delta: float) -> void:
	pass

func putdown(delta: float) -> void:
	pass

func chop(delta: float) -> void:
	pass

## Movement Code
var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("LEFT", "RIGHT")

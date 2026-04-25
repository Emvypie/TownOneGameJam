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
@export var speed = 400
var move_input: Vector2 = Vector2.ZERO

func _ready() -> void:
	current_state = initial_state
	for area in get_tree().get_nodes_in_group("detection_areas"):
		area.body_entered.connect(_on_area_body_entered.bind(area))
		area.body_exited.connect(_on_area_body_exited.bind(area))
	
	#for block in get_tree().get_nodes_in_group("chopping_block"):
		#block.body_entered.connect(_on_block_body_entered.bind(block))
		#block.body_exited.connect(_on_area_body_exited.bind(block))
#

func _on_area_body_entered(body: Node3D, area: Area3D):
	if body == self:
		print("I entered: ", area.name)
		picked_object = area
		print(picked_object)

#func _on_block_body_
		
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
	
	direction.x -= horizontal_movement
	direction.z += vertical_movement

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Ground Velocity
	velocity.x = direction.x * speed * delta
	velocity.z = direction.z * speed * delta 

	# Moving the Character
	move_and_slide()

	if move_input == Vector2.ZERO:
		current_state = EStates.IDLE

## Action Code

func pickup() -> void:
	print("---------- NEW PICKUP SEQUENCE")
	print("picked object: ", picked_object)
	print("hold position; ", hold_position)
	if picked_object == null:
		return

	picked_object.reparent(hold_position)
	print(picked_object)

func putdown() -> void:
	print("--------- PUT DOWN STARTED")
	print("putting down object: ", picked_object)
	if picked_object != null:
		# Re-enable physics and return to world
		picked_object.position.x += 0.0001
		picked_object.reparent(get_tree().root) # Or your world node
		picked_object = null
	print("--------- PUT DOWN COMPLETED")


## Movement Code
var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("LEFT", "RIGHT")

#
#func _on_body_area_entered(area: Area3D) -> void:
	#pass # Replace with function body.
#
#
#func _on_body_area_exited(area: Area3D) -> void:
	#pass # Replace with function body.


func _on_area_body_exited(area: Area3D) -> void:
	pass # Replace with function body.

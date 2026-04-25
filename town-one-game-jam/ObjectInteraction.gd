extends Area3D

enum States {
	HELD,
	PLACED
}

signal on_current_state_changed(state: States)
var initial_state: States = States.PLACED
var has_entered: bool = false
signal scene_entered(path)

var _current_state: States = States.PLACED
var current_state: States:
	get:
		return _current_state
	set(value):
		if _current_state != value:
			_current_state = value
			on_current_state_changed.emit(value)

@onready var hold_position = $"../Camera/Marker3D"
var picked_object = null
var range_radius = 20
var interact_input: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: CharacterBody3D):
	if body.name == 'KB_Player':
		print('Player entered area')
		has_entered = true
		scene_entered.emit("res://levels/level_2.tscn")

func _on_body_exited(body: CharacterBody3D):
	if body.name == 'KB_Player':
		print('Player exited area')
		has_entered = false
		
func set_state(new_state) -> void:
	current_state = States.HELD
	
func place() -> void:
	print("place")
	if picked_object:
		# Move back to world root or a specific "World" node
		picked_object.reparent(get_tree().current_scene)
		if picked_object is RigidBody3D:
			picked_object.freeze = false
		picked_object = null

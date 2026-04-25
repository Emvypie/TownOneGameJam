extends Area3D

enum States {
	HELD,
	PLACED
}

@onready var raycast = $Camera/RayCast3D
@onready var hold_position = $Camera/Marker3D
var picked_object = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func pickup() -> void:
	print("pickup")
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("pickable"):
			picked_object = collider
			# For physics objects, freeze them so they don't fall while held
			if picked_object is RigidBody3D:
				picked_object.freeze = true
			
			# Reparent or snap to hold position
			picked_object.reparent(hold_position)
			picked_object.position = Vector3.ZERO
			picked_object.rotation = Vector3.ZERO

func place() -> void:
	print("place")
	if picked_object:
		# Move back to world root or a specific "World" node
		picked_object.reparent(get_tree().current_scene)
		if picked_object is RigidBody3D:
			picked_object.freeze = false
		picked_object = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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


## Signals
signal on_current_state_changed(state: EStates)


# Onready vars
@onready var hold_position = $"."
@onready var player_a_label = $"../../PlayerALabel"
@onready var player_b_label = $"../../PlayerBLabel"
@onready var timer = $"../../../Timer"
#@onready var game_over_scene = get_tree().get("res://GameOver_Scene.tscn")


# Private vars
var initial_state: EStates = EStates.IDLE
var rotation_direction = 0
var _current_state: EStates = EStates.IDLE
var current_state: EStates:
	get:
		return _current_state
	set(value):
		if _current_state != value:
			_current_state = value
			on_current_state_changed.emit(value)
var picked_object = null
var chopping_block = null
var player_a_score = 0
var player_b_score = 0
var leaderboard = null

var move_input: Vector2 = Vector2.ZERO


## -----------------------------------------------------------------------------
## Export Variables
## -----------------------------------------------------------------------------

@export_group("3D")
@export var rotation_speed: float = 10.0
@export var camera_pivot: Node3D
@export var speed = 600


## Predefined function overwrites

func _ready() -> void:
	leaderboard = $"../../../Leaderboard/Control"
	leaderboard.visible = false
	current_state = initial_state
	for area in get_tree().get_nodes_in_group("triggers"):
		area.body_entered.connect(_on_area_body_entered.bind(area))
		area.body_exited.connect(_on_area_body_exited.bind(area))
	
	for block in get_tree().get_nodes_in_group("chopping_block"):
		block.body_entered.connect(_on_block_body_entered.bind(block))
		block.body_exited.connect(_on_block_body_exited.bind(block))

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

func _process(delta) -> void:
	#print("timer: ", timer.get_child(0))
	if player_a_score == 0:
		ScoreManager.load_score()
	timer.get_child(0).timeout.connect(_on_timer_timeout)

	
func _input(event):
	if event.is_action_pressed("PICKUP"):
		pickup()
	if event.is_action_pressed("PUTDOWN"):
		putdown()
	if event.is_action_pressed("PLAYER_A_BTN_1") or event.is_action_pressed("PLAYER_A_BTN_2"):
		update_labels("A")
	if event.is_action_pressed("PLAYER_B_BTN_1") or event.is_action_pressed("PLAYER_B_BTN_2"):
		update_labels("B")



## Custom signals

func _on_area_body_entered(body: Node3D, area: Area3D):
	if body == self:
		picked_object = area

func _on_area_body_exited(area: Area3D) -> void:
	pass

func _on_block_body_entered(body: CharacterBody3D, block: Area3D):
	if body == self:
		chopping_block = block

func _on_block_body_exited(body: CharacterBody3D, area: Area3D):
	if body == self:
		area.position.x += 0.0001
		chopping_block = null

func _on_timer_timeout():
	ScoreManager.update_score("playera", player_a_score)
	ScoreManager.update_score("playerb", player_b_score)
	#update_leaderboard()
	# Update global score


## Movement Code

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

func get_input():
	rotation_direction = Input.get_axis("LEFT", "RIGHT")


## Action Code

func pickup() -> void:
	if picked_object == null:
		return

	# reparent to the character
	picked_object.reparent(hold_position)

func putdown() -> void:
	if picked_object != null:
		if chopping_block != null:
			# This line is to fix a known bug to exit the
			# "area entered" so it no longer gets triggered
			picked_object.position.x += 0.0001
			
			# Smooth animation of placement
			var tween = create_tween()
			var top_of_block = chopping_block.global_position + Vector3(0,4,0)
			tween.tween_property(picked_object, "global_position", top_of_block, 0.2)
			picked_object.reparent(get_tree().root)
			
			# Clear selected objects
			picked_object = null
			chopping_block = null


## Incrementers
func update_labels(player: String):
	if player == "A":
		player_a_score+=1
		player_a_label.text = "Player A: " + str(player_a_score)
	else:
		player_b_score+=1
		player_b_label.text = "Player B: " + str(player_b_score)
	#ScoreManager.update_score(player_a_score)
		

# Leaderboard
#func update_leaderboard():
	#leaderboard.visible = true
	#print("visible: ", leaderboard)
	#get_tree().paused = true
	#print("gos: ", game_over_scene)

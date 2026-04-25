
extends Node3D

@export var score_counter_path: NodePath

var player_near = false
var score_counter = null

func _ready():
	score_counter = get_node(score_counter_path)

	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)

func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):
		score_counter.add_score()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_near = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_near = false

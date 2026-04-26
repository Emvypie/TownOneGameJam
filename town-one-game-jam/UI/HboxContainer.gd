extends HBoxContainer

enum modes {SIMPLE, EMPTY, PARTIAL}
var count = 0
var heart_full = preload("res://UI/hud_heartFull.png")
var heart_empty = preload("res://UI/hud_heartEmpty.png")

@export var mode : modes

func update_tickets(value):
	match mode:
		modes.SIMPLE:
			update_simple(value)
		modes.EMPTY:
			update_empty(value)

func update_simple(value):
	print("simple")
	print(value)
	for i in get_child_count():
		get_child(i).visible = value > i

func update_empty(value):
	for i in get_child_count():
		print("empty")

		if value > i:
			get_child(i).texture = heart_full
		else:
			get_child(i).texture = heart_empty

func _ready() -> void:
	for star in get_tree().get_nodes_in_group("stars"):
		star.visible = 0
	pass

func _draw_star(star) -> void:
	star.draw()

func _on_timer_timeout() -> void:
	if count > 3:
		return

	update_tickets(count)
	count += 1
	print("timer")
	print(count)

extends Node

var high_score = 0
const SAVE_PATH = "user://highscore.save"

func _ready():
	load_score()

func update_score(new_score):
	print("update score")
	print(new_score)
	print(high_score)
	if new_score > high_score:
		high_score = new_score
		save_score()

func save_score():
	print("saving")
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE_READ)
	if file:
		file.store_var(high_score)
		file.close()

func load_score():
	print("loading")
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	print('ok: ', file)
	if FileAccess.file_exists(SAVE_PATH):
		print("exists")
		if file:
			high_score = file.get_var()
			file.close()

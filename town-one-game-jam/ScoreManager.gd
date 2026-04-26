extends Node

var high_score = 0
var user_score_dict = {}
const SAVE_PATH = "user://highscore.save"

func _ready():
	load_score()

func update_score(user, new_score):
	var user_high_score = 0
	load_score()
	print(user_score_dict)
	if user in user_score_dict:
		if new_score > user_score_dict[user]:
			user_high_score = user_score_dict[user]

	if new_score > user_high_score:
		user_score_dict[user] = new_score

	save_score()

func save_score():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(user_score_dict)
	print(user_score_dict)
	file.close()
	load_score()

func load_score():
	print("loading")
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if file:
			user_score_dict = file.get_var()
			#print(user_score_dict)
			file.close()

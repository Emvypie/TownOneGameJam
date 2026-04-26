extends Node2D

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/LevelOne.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Options_Scene.tscn")

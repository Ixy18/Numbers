extends Control

@export_file('*.tscn') var game_scene 

func _on_button_pressed_play():
		get_tree().change_scene_to_file(game_scene)

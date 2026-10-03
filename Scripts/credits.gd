extends Control

@onready var click_sound := $click_button_sound

func _on_button_back_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

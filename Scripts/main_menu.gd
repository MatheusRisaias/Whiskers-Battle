extends Control

@onready var click_sound := $click_button_sound

func _on_start_button_pressed() -> void:
	click_sound.play()
	get_tree().change_scene_to_file("res://Scenes/choose_mode.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")

func _on_insta_pressed() -> void:
	OS.shell_open("https://www.instagram.com/violetdrizzle_/")


func _on_itchio_pressed() -> void:
	OS.shell_open("https://violet-drizzle.itch.io/")


func _on_x_pressed() -> void:
	OS.shell_open("https://x.com/VioletDrizzle_")

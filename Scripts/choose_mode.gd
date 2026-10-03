extends Control
@onready var arena := $"../Arena"
@onready var click_sound := $click_button_sound
var arena_scene = preload("res://Scenes/Arena_Scenes/arena.tscn")


func _on_singleplayer_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://Scenes/Arena_Scenes/arena.tscn")


func _on_multiplayer_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	var arena = arena_scene.instantiate()
	arena.coop = true
	get_tree().root.add_child(arena)


func _on_button_back_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

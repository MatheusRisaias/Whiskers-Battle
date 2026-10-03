extends Control
@onready var arena := $"../Arena"
var arena_scene = preload("res://Scenes/Arena_Scenes/arena.tscn")

#@onready var jade : CharacterBody2D = $"./Pla"
#@onready var salem : CharacterBody2D = $"../Players/Salem"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jade_pressed() -> void:
	#jade.select_jade = true
	var arena = arena_scene.instantiate()
	arena.coop = false
	get_tree().root.add_child(arena)

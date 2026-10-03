extends Node2D

@export var speed := 25.0
@export var x_min := 20.0
@export var x_max := 500.0
@export var y_min := 20.0
@export var y_max := 700.0

var target_position : Vector2


func _ready() -> void:
	randomize()
	
	position.x = randf_range(x_min, x_max)
	position.y = randf_range(y_min, y_max)
	
	choose_new_target()


func _process(delta: float) -> void:
	var direction := global_position.direction_to(target_position)
	
	global_position += direction * speed * delta
	
	if global_position.distance_to(target_position) < 5.0:
		choose_new_target()


func choose_new_target() -> void:
	target_position = Vector2(
		randf_range(x_min, x_max),
		randf_range(y_min, y_max)
	)

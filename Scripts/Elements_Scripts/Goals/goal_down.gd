extends Area2D

@export var goal_point_salem : int = 0

@onready var point_salem := $"../../Scores/Salem_Points/Points_Salem"
@onready var ball := $"../../Ball"


func _process(_delta: float) -> void:
	point_salem.text = str(goal_point_salem)
	visible = true

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		var effect = $AnimatedSprite2D.duplicate()
		get_parent().add_child(effect)

		effect.global_position = area.global_position
		effect.global_position.y -= 28
		effect.visible = true
		effect.play("goal")
		await effect.animation_finished

		effect.queue_free()
		ball.reset_ball()

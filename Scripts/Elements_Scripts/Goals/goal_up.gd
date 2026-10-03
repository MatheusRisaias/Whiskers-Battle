extends Area2D

@export var goal_point_jade : int = 0

@onready var point_jade := $"../../Scores/Jade_Points/Points_Jade"
@onready var ball := $"../../Ball"

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	point_jade.text = str(goal_point_jade)



func _on_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		var effect = $AnimatedSprite2D.duplicate()
		get_parent().add_child(effect)
		
		effect.flip_v = true
		effect.global_position = area.global_position
		effect.global_position.y += 40
		effect.visible = true
		effect.play("goal")
		await effect.animation_finished

		effect.queue_free()
		ball.reset_ball()

extends Area2D

@onready var arena : Node2D = $".."
@onready var salem : CharacterBody2D = $"../Players/Salem"
@onready var jade : CharacterBody2D = $"../Players/Jade"

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Ball" and arena.its_jade == true:
		jade.speed_movement = jade.speed_movement + 10
		$AudioStreamPlayer.play()
		$Animated.play("caught")
		$CollisionShape2D.set_deferred("disabled", true)
	elif area.name == "Ball" and arena.its_salem == true:
		salem.speed_movement = salem.speed_movement + 10
		$AudioStreamPlayer.play()
		$Animated.play("caught")
		$CollisionShape2D.set_deferred("disabled", true)

func _on_animated_animation_finished() -> void:
	queue_free()

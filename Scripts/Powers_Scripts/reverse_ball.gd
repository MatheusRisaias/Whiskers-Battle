extends Area2D


@onready var arena : Node2D = $".."
@onready var salem : CharacterBody2D = $"../Players/Salem"
@onready var jade : CharacterBody2D = $"../Players/Jade"
@onready var ball : Area2D = $"../Ball"

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Ball" and arena.its_jade == true:
		ball.new_direction *= -1
		$AnimatedSprite2D.play("caught")
		$AudioStreamPlayer.play()
		$CollisionShape2D.set_deferred("disabled", true)
	elif area.name == "Ball" and arena.its_salem == true:
		ball.new_direction *= -1
		$AudioStreamPlayer.play()
		$AnimatedSprite2D.play("caught")
		$CollisionShape2D.set_deferred("disabled", true)


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

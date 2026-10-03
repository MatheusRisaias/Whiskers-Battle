extends Area2D

@onready var arena : Node2D = $".."
@onready var salem : CharacterBody2D = $"../Players/Salem"
@onready var jade : CharacterBody2D = $"../Players/Jade"
@onready var ball : Area2D = $"../Ball"

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Ball" and arena.its_jade == true:
		$AudioStreamPlayer.play()
		$Timer.start()
		jade.its_move = false
		$AnimatedSprite2D.play("caught")
		$CollisionShape2D.set_deferred("disabled", true)
	elif area.name == "Ball" and arena.its_salem == true:
		$AudioStreamPlayer.play()
		$Timer.start()
		salem.its_move = false 
		$AnimatedSprite2D.play("caught")
		$CollisionShape2D.set_deferred("disabled", true)

func _on_timer_timeout() -> void:
	if jade.its_move == false:
		jade.its_move = true
	if salem.its_move == false:
		salem.its_move = true
	queue_free() # Destrói o power apenas depois de destravar os jogadores
func _on_animated_sprite_2d_animation_finished() -> void:
		$AnimatedSprite2D.hide() # Esconde o visual sem destruir o Timer

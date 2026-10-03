extends Area2D

var ativado := false

var posicoes = [
	Vector2(100, 320),
	Vector2(170, 320),
	Vector2(245, 320),
	Vector2(325, 320),
]


func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	
	position = posicoes.pick_random()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Ball" and ativado == false:
		ativado = true
		
		$AnimatedSprite2D.play("Sink")
		await $AnimatedSprite2D.animation_finished
		
		$Timer.start()


func _on_timer_timeout() -> void:
	position = posicoes.pick_random()
	$AnimatedSprite2D.play("Wake_Up")
	await $AnimatedSprite2D.animation_finished
	
	ativado = false
	$AnimatedSprite2D.play("Idle")
	$Timer.stop()

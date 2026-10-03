extends Area2D

@onready var goal_salem : Area2D = $"../Goals/Goal_Down"
@onready var goal_jade : Area2D = $"../Goals/Goal_Up"
@onready var arena : Node2D = $".."
@onready var jade : CharacterBody2D = $"../Players/Jade"
@onready var salem : CharacterBody2D = $"../Players/Salem"
@onready var timer : Timer = $Timer
@onready var line_2d : Line2D = $Line2D
@onready var sprite: Sprite2D = $Sprite2D # Ajuste para o nome do seu nó de sprite


@export var speed_moviment_ball := 200.0
@export var x_min : float
@export var x_max : float

var time_off : bool = false
var speed_start := 200.0
var inicial_position : Vector2 = Vector2(226, 320)
var new_direction : Vector2 = Vector2.ZERO
var rotation_random = [1, -1].pick_random()
var reverse : bool = false

var max_trail_count : int = 20
var inicial_max_trail_count := 20

func _ready() -> void:
	reset_ball()

func _process(delta : float) -> void:
	# Só move e gira a bola se o tempo de espera tiver acabado
	if time_off:
		update_ball_position(delta)
		ball_rotation(delta)
		
		if speed_moviment_ball >= 250:
			# Adiciona o ponto convertendo para o espaço local do Line2D
			line_2d.add_point(global_position)
			
			# Mantém o rastro dentro do tamanho máximo
			while line_2d.points.size() > max_trail_count:
				line_2d.remove_point(0)
		
		if speed_moviment_ball >= 340:
			max_trail_count = 50
		else:
			max_trail_count = inicial_max_trail_count
		

func apply_smoosh() -> void:
	# Cancela qualquer tween anterior no sprite para evitar conflitos se rebater rápido
	var tween = create_tween()
	
	# 1. Achata na direção do impacto e estica no eixo oposto
	# (Exemplo: rebateu na parede vertical ou no jogador)
	tween.tween_property(sprite, "scale", Vector2(2.4, 1.8), 0.08)\
		 .set_trans(Tween.TRANS_QUAD)\
		 .set_ease(Tween.EASE_OUT)
		
	# 2. Volta ao tamanho normal (Vector2(1, 1)) suavemente com um efeito de mola
	tween.tween_property(sprite, "scale", Vector2(2.0, 2.0), 0.15)\
		 .set_trans(Tween.TRANS_BOUNCE)\
		 .set_ease(Tween.EASE_OUT)
# Função central para resetar a bola e iniciar o timer de 1s
func reset_ball() -> void:
	arena.its_jade = false
	arena.its_salem = false
	time_off = false
	new_direction = Vector2.ZERO
	position = inicial_position
	speed_moviment_ball = speed_start
	max_trail_count = inicial_max_trail_count
	# LIMPA O RASTRO ACUMULADO AO FAZER GOL
	if line_2d:
		line_2d.clear_points()
	timer.start()

func choose_direction() -> void:
	jade.speed_movement = 200.0
	salem.speed_movement = 200.0
	
	arena.its_salem = false
	arena.its_jade = false
	
	# Mudar de graus para radianos escolhendo aleatoriamente
	var angle := deg_to_rad(randf_range(-60, 60))
	var direction_multiplier = [-1, 1].pick_random()
	
	new_direction = Vector2.from_angle(angle)
	new_direction.x *= direction_multiplier
	new_direction = new_direction.normalized()

func update_ball_position(delta : float) -> void:
	position += new_direction * speed_moviment_ball * delta
	wall_collision(delta)

func ball_rotation(delta : float) -> void:
	var rotation_speed := 200
	rotation_degrees += rotation_speed * rotation_random * delta

func wall_collision(_delta : float) -> void:
	if position.x <= x_min:
		new_direction.x *= -1
		speed_moviment_ball += 10
		spawn_impact_effect(true) # Passa true para inverter na parede esquerda
		$AudioStreamPlayer.play()
		apply_smoosh()
	elif position.x >= x_max:
		new_direction.x *= -1
		speed_moviment_ball += 10
		spawn_impact_effect(false) # Passa false para manter normal na direita
		$AudioStreamPlayer.play()
		apply_smoosh()

func spawn_impact_effect(is_left_wall: bool) -> void:
	# Duplica o AnimatedSprite2d existente
	var effect = $AnimatedSprite2d.duplicate() as AnimatedSprite2D
	
	# Adiciona o efeito na cena principal (ou no nó pai da bola)
	get_parent().add_child(effect)
	
	#Define a posição e o flip do efeito duplicado
	effect.global_position = global_position
	effect.flip_h = is_left_wall
	effect.visible = true
	
	# Conecta o sinal via código para deletar o efeito duplicado ao terminar
	effect.animation_finished.connect(func(): effect.queue_free())
	
	# Toca a animação
	effect.play("impact")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		apply_smoosh()
		# 1. Distância relativa (-1.0 = extrema esquerda, 0.0 = centro, 1.0 = extrema direita)
		var shape_width : float = body.get_node("CollisionShape2D").shape.get_rect().size.x / 2.0
		var offset_x : float = (global_position.x - body.global_position.x) / shape_width
		offset_x = clamp(offset_x, -1.0, 1.0)
		
		# 2. Direção vertical Y (1.0 = para baixo, -1.0 = para cima)
		var dir_y : float = 1.0 if global_position.y > body.global_position.y else -1.0

		# 3. Definição da ZONA MORTA do centro (0.35 representa os 35% centrais da raquete)
		var dead_zone : float = 0.2 #o meio perfeito seja reto, 0.2.

		if abs(offset_x) <= dead_zone:
			# IMPACTO NO CENTRO: Rebatida simples mantendo a direção X original (comportamento inicial)
			new_direction.y = dir_y
			new_direction = new_direction.normalized()
		else:
			# IMPACTO NAS EXTREMIDADES: Calcula a curva apenas para a área além da zona morta
			# Mapeia a variação de (dead_zone ate 1.0) para (0.0 ate 1.0)
			var edge_factor : float = (abs(offset_x) - dead_zone) / (1.0 - dead_zone)
			
			# Mantém o sinal (+ para direita, - para esquerda)
			if offset_x < 0:
				edge_factor *= -1.0

			var max_angle : float = deg_to_rad(55.0)
			var bounce_angle : float = edge_factor * max_angle

			new_direction = Vector2(sin(bounce_angle), dir_y * cos(abs(bounce_angle))).normalized()

	elif reverse:
		new_direction.y *= -1

	# Atualização de textura e registros da arena
	if body.name == "Jade":
		arena.its_jade = true
		arena.its_salem = false
		$AudioStreamPlayer.play()
		#$Sprite2D.texture = load("res://PERSONAGENS/ball.png")
	elif body.name == "Salem":
		arena.its_salem = true
		arena.its_jade = false
		$AudioStreamPlayer.play()
		#$Sprite2D.texture = load("res://PERSONAGENS/ball.png")

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Goal_Down":
		goal_salem.goal_point_salem += 1
		
	elif area.name == "Goal_Up":
		goal_jade.goal_point_jade += 1


func _on_timer_timeout() -> void:
	time_off = true
	choose_direction()

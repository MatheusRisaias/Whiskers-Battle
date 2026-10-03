extends CharacterBody2D

@export var speed_movement := 200.0
@export var deadzone: float = 12.0 # Margem em pixels para evitar o tremor

@onready var arena := $"../.."
@onready var ball := $"../../Ball"
var select_salem
var its_move : bool = true
func _physics_process(_delta: float) -> void:
	if its_move:
		moveSalem() #responsavel pela movimentação de Salem
	move_and_slide()
	position.x = clamp(position.x, 100, 370)

func moveSalem() -> void:
	if arena.coop or select_salem: # se a variavel coop for verdadeira
		var direction := Input.get_axis("salem_move_left", "salem_move_right")
		velocity.x = direction * speed_movement
	else: # ativa a IA
		if arena.its_jade || ball.global_position.y <= 320:
			# Usamos global_position para evitar bugs de nó pai/filho
			var diff = ball.global_position.x - global_position.x
			
			# Só move se a distância horizontal for maior que a margem de tolerância
			if abs(diff) > deadzone:
				velocity.x = sign(diff) * speed_movement
			else:
				velocity.x = 0

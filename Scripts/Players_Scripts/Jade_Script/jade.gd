extends CharacterBody2D

@export var speed_movement := 200.0
@onready var arena := $"../.."
var select_jade : bool
var its_move : bool = true
func _physics_process(_delta: float) -> void:
	if its_move:
		moveJade() #responsavel pela movimentação de Jade
	else:
		velocity.x = 0
	move_and_slide()
	position.x = clamp(position.x, 100, 370)

func moveJade() -> void:
	if arena.coop or !arena.coop: #se a variavel coop for verdadeira ou falsa
		var direction := Input.get_axis("jade_move_left", "jade_move_right")
		velocity.x = direction * speed_movement

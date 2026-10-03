extends Node2D

@export var coop : bool = false
@export var goal_for_win : int = 3

@export var firefly_scene : PackedScene
@export var firefly_amount := 10

@export var power_up_scenes : Array[PackedScene] = []
# limites da área do mapa onde o Power-Up pode aparecer
@export var x_min : float = 100.0
@export var x_max : float = 260.0
@export var y_min : float = 140.0
@export var y_max : float = 450.0

@onready var fireflies : Node2D = $Fireflies
@onready var spawn_timer : Timer = $SpawnTimer

# Guarda a referência do Power-Up ativo no momento
var current_power_up : Node2D = null
@onready var jade : CharacterBody2D = $Players/Jade
@onready var salem : CharacterBody2D = $Players/Salem
@onready var goal_down := $Goals/Goal_Down
@onready var goal_up := $Goals/Goal_Up


var game_finished := false
var its_jade : bool = false
var its_salem : bool = false

func _ready() -> void:
	spawn_fireflies()


func spawn_fireflies() -> void:
	for i in firefly_amount:
		var firefly = firefly_scene.instantiate()
		
		firefly.x_min = 30
		firefly.x_max = 450
		firefly.y_min = 30
		firefly.y_max = 700
		
		fireflies.add_child(firefly)

func _process(_delta: float) -> void:
	if not game_finished:
		count_goals_for_win()
	if game_finished:
		queue_free()

#função responsável em contar a quantidade de gols 
#nescessárias para o jogador vencer
func count_goals_for_win():
	if goal_down.goal_point_salem >= goal_for_win:
		game_finished = true
		get_tree().change_scene_to_file("res://Scenes/Screens_Win/salem_win.tscn")
	elif goal_up.goal_point_jade >= goal_for_win:
		game_finished = true
		get_tree().change_scene_to_file("res://Scenes/Screens_Win/jade_win.tscn")


func _on_spawn_timer_timeout() -> void:
	# Regra: Se ainda existir um Power-Up vivo/ativo no mapa, não instancia outro
	if is_instance_valid(current_power_up):
		return
	
	# Garante que existem cenas configuradas na lista
	if power_up_scenes.is_empty():
		return
	
	spawn_random_power_up()

func spawn_random_power_up() -> void:
	# Escolhe uma cena aleatória da lista de Power-Ups
	var random_scene : PackedScene = power_up_scenes.pick_random()
	
	# Instancia o nó na memória
	current_power_up = random_scene.instantiate() as Node2D
	
	# Calcula uma posição aleatória dentro dos limites definidos
	var random_x := randf_range(x_min, x_max)
	var random_y := randf_range(y_min, y_max)
	current_power_up.position = Vector2(random_x, random_y)
	
	# Adiciona o Power-Up à cena principal (como filho deste nó)
	add_child(current_power_up)

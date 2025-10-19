class_name main
extends WorldEnvironment
@onready var casa_points: Node2D = $World/Casa_points



@onready var ui: ui = $UI
@onready var spawns: Node2D = $World/Spawns
@onready var inimigos: Node2D = $World/Inimigos
const ENEMY = preload("res://Scenes/Enemy/enemy.tscn")
@onready var color_rect: ColorRect = $ColorRect

var wave_counter: int = 0
var waves_difficulty: Array = [5, 8, 15] # Numero de Inimigos por marker

var summoning = false

func _process(delta: float) -> void:
	print(wave_counter, waves_difficulty.size(), inimigos.get_children().size())
	if wave_counter == waves_difficulty.size():
		get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")
		
	if inimigos.get_children().size() < 2 and not summoning:
		new_horde()


func enemy_defeated(value: int = 10):
	ui.update_money(value)

func new_horde():
	summoning = true
	var spawn_locs = 1 # Quantidade de spawns que serao usados
	var markers = spawns.get_children()
	for spawn in range(spawn_locs):
		var loc = markers.pop_back()
		for __ in range(waves_difficulty[wave_counter]):
			var enemy = ENEMY.instantiate()
			inimigos.add_child(enemy)
			enemy.global_position = loc.global_position + Vector2(randi_range(-100, +100) * 10,randi_range(-100, +100) * 10)
			enemy.target = casa_points.get_children().pick_random()
	wave_counter += 1
	summoning = false

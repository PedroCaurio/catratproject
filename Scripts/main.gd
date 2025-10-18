class_name main
extends WorldEnvironment
@onready var casa: Marker2D = $Casa

@onready var ui: ui = $UI
@onready var spawns: Node2D = $World/Spawns
@onready var inimigos: Node2D = $World/Inimigos
const ENEMY = preload("res://Scenes/Enemy/enemy.tscn")
@onready var color_rect: ColorRect = $ColorRect

var difficulty: int = 2 # Numero de Inimigos por marker


func _process(delta: float) -> void:
	#await get_tree().create_timer(5.0).timeout
	
	if Input.is_action_just_pressed("horda"):
		new_horde()

func enemy_defeated(value: int = 10):
	ui.update_money(value)

func new_horde():
	var spawn_locs = randi_range(1, 4) # Quantidade de spawns que serao usados
	
	var markers = spawns.get_children()
	for spawn in range(spawn_locs):
		var loc = markers.pop_back()
		print(loc)
		for __ in range(difficulty):
			var enemy = ENEMY.instantiate()
			inimigos.add_child(enemy)
			enemy.global_position = loc.global_position + Vector2(randi_range(-5, 5) * 4,randi_range(-5, 5) * 4)
			enemy.target = casa
			   
			
			
			

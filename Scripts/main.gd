class_name Main
extends WorldEnvironment

@onready var casa_points: Node2D = $World/Casa_points
@onready var camera: Camera2D = $Player/camera
@onready var spawns: Node2D = $World/Spawns
@onready var inimigos: Node2D = $World/Inimigos

# 🎵 Sons principais das hordas
@onready var horde_sounds: Array[AudioStreamPlayer] = [
	$Hordes_sounds/Tutorial,
	$Hordes_sounds/Horde1,
	$Hordes_sounds/Horde2,
	$Hordes_sounds/Horde3
]

# 🔊 Sons de transição (tocam antes da música da horda)
@onready var transition_sounds: Array[AudioStreamPlayer] = [
	$Hordes_sounds/Transition1,
	$Hordes_sounds/Transition2,
	$Hordes_sounds/Transition3
]

const ENEMY = preload("res://Scenes/Enemy/enemy.tscn")

var wave_counter: int = 0
var waves_difficulty: Array = [5, 8, 15] # número de inimigos por horda
var summoning := false

func _process(delta: float) -> void:
	if wave_counter == waves_difficulty.size():
		get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")
		return

	if inimigos.get_child_count() < 1 and not summoning:
		new_horde()

func new_horde() -> void:
	summoning = true

	# Espera antes da próxima horda
	await get_tree().create_timer(1.5).timeout

	# 🔊 Toca transição se houver (não há no tutorial)
	if wave_counter < transition_sounds.size():
		for t in transition_sounds:
			t.stop()
		transition_sounds[wave_counter].play()
		await transition_sounds[wave_counter].finished  # espera a transição acabar

	# 🎵 Toca o som principal da horda
	if wave_counter < horde_sounds.size():
		for sound in horde_sounds:
			sound.stop()
		horde_sounds[wave_counter].play()

	# Spawna inimigos
	var spawn_locs := 1
	var markers := spawns.get_children()

	for spawn in range(spawn_locs):
		var loc = markers.pop_back()
		for __ in range(waves_difficulty[wave_counter]):
			var enemy = ENEMY.instantiate()
			inimigos.add_child(enemy)
			enemy.global_position = loc.global_position + Vector2(randi_range(-100, 100), randi_range(-100, 100)) * 10
			enemy.target = casa_points.get_children().pick_random()
			enemy.enemy_killed.connect(shake_cam)

	wave_counter += 1
	summoning = false

func shake_cam():
	print("shake shake")
	camera.start_hitstop(0.1)
	

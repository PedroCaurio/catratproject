extends State

@export var idle_state: State
@export var move_state: State
@export var hurt_state: State
@onready var state_machine: StateMachine = $".."

func enter() -> void:
	if parent.global_position.direction_to(parent.get_global_mouse_position()).x < 0.0:
		parent.animation.flip_h = false
	elif parent.global_position.direction_to(parent.get_global_mouse_position()).x > 0.0:
		parent.animation.flip_h = true
	super()

func process_input(_event: InputEvent) -> State:
	print(parent.global_position.direction_to(parent.get_global_mouse_position()).x < 0.0)
	
	animation_shoot()
	return null
	
func animation_shoot()-> void:
	await parent.animation.animation_finished
	state_machine.change_state(idle_state)
	parent.shoot()
	print("fim")
'''
func shoot_function():	
	if municao <= 0:
		return

	esta_atirando = true
	tiros_jogador += 1
	municao -= 1

	# Instancia o projétil
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = shoot_point.global_position

	# Define direção do projétil
	var dir = Vector2.RIGHT if not sprite_animado.flip_h else Vector2.LEFT
	projectile.initialize(dir)
	
	await get_tree().create_timer(0.2).timeout
	esta_atirando = false
'''

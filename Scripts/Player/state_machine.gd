class_name StateMachine
extends Node

@export var starting_state: State
@onready var hurt: State = $hurt
var taking_damage = false
var current_state: State
var parent : Player
func init(player: Player) -> void:
	parent = player
	for child in get_children():
		child.parent = player
	
	change_state(starting_state)
	
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
	
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
	
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
	
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
		
func take_damage() -> void:
	return
	if not taking_damage:
		taking_damage = true
		change_state(hurt)
		
func immortal_time() -> void:
	await get_tree().create_timer(3.0).timeout
	taking_damage = false

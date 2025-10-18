extends State
@export var idle_state: State

@onready var state_machine: StateMachine = $".."

func process_input(event: InputEvent) -> State:
	hurt()
	return null
	
func hurt()-> void:
	#await parent.animation.animation_finished
	print("animation finished")
	await get_tree().create_timer(1.0).timeout
	state_machine.change_state(idle_state)

extends State
@export var idle_state: State

@onready var state_machine: StateMachine = $".."

func process_input(event: InputEvent) -> State:
	hurt()
	return null
func process_physics(delta: float) -> State:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	parent.slow()
	
	parent.velocity = direction * parent.speed
	if direction.x < 0:
		parent.animation.flip_h = false
	elif direction.x > 0:
		parent.animation.flip_h = true
	parent.move_and_slide()
	return null
func hurt()-> void:
	#await parent.animation.animation_finished
	await get_tree().create_timer(3.0).timeout
	state_machine.change_state(idle_state)

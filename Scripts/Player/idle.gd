extends State


@export var shoot_state: State
@export var move_state: State
@export var hurt_state: State

func enter() -> void:
	super()
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("shoot") and parent.current_ammo >0:
		return shoot_state
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		return move_state
	return null

func process_physics(delta: float) -> State:
	return null

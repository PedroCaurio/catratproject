extends State

@export var shoot_state: State
@export var idle_state: State


func enter() -> void:
	super()
	
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("shoot") and parent.current_ammo >0:
		print("shooting")
		
		return shoot_state
	return null
	
func process_physics(delta: float) -> State:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		return idle_state
	parent.velocity = direction * parent.speed
	if direction.x < 0:
		parent.animation.flip_h = false
	elif direction.x > 0:
		parent.animation.flip_h = true
	parent.move_and_slide()
	
	return null

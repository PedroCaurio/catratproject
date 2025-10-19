extends Camera2D

var original_position := Vector2.ZERO
var shake_amount :=700
var is_hitstopping := false

@onready var timer := $"../Timer"

func _ready():
	original_position = position
	process_mode = Node.PROCESS_MODE_ALWAYS

	
	

func start_hitstop(duration: float):
	if is_hitstopping:
		return
	is_hitstopping = true
	original_position = position
	timer.timeout.connect(_on_timer_timeout)
	timer.start(0.8)
	

func _on_hitstop_timeout():
	is_hitstopping = false
	position = original_position

func _process(_delta):
	if is_hitstopping:
		position = original_position + Vector2(randf() - 0.5, randf() - 0.5) * shake_amount *_delta


func _on_timer_timeout() -> void:
	is_hitstopping = false
	position = original_position

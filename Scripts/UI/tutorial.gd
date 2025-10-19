extends Control

@onready var timer: Timer = $timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	animation_player.play("tutorial")
	timer.start()

func _on_timer_timeout() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

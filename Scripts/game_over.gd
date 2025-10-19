extends Control

@onready var gameover_sound: AudioStreamPlayer = $gameover

func _ready() -> void:
	gameover_sound.play()
	await gameover_sound.finished
	
func _on_sair_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_tentar_dnv_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

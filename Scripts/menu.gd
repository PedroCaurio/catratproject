extends Control

@onready var menu_ost: AudioStreamPlayer = $menu_ost
const MAIN = preload("res://Scenes/main.tscn")
func _ready() -> void:
	menu_ost.play()


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()

extends Control

@onready var ost_finished: AudioStreamPlayer = $ost_finished

func _on_sair_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

func _on_créditos_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Creditos.tscn")

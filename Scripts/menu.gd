extends Control

func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()

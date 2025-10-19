class_name MapObject
extends StaticBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Playerrr")
		sprite_2d.self_modulate = Color(1, 1, 1, 0.2)
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		sprite_2d.self_modulate = Color(1, 1, 1, 1)

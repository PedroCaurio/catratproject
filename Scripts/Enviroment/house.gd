class_name House
extends StaticBody2D

var hp: int = 5
@onready var vida: Label = $Vida




func _process(delta: float) -> void:
	vida.text = str(hp)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.queue_free()
	hp -= 1
	if hp == 0:
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")

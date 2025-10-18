class_name House
extends StaticBody2D

var hp: int = 5
@onready var vida: Label = $Vida


func _on_hurtbox_area_entered(area: Area2D) -> void:
	hp -= 1

func _process(delta: float) -> void:
	vida.text = str(hp)

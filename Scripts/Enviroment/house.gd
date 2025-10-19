class_name House
extends StaticBody2D

var hp: int = 3
@onready var vida: Label = $Vida
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var damage_house: AudioStreamPlayer2D = $Damage_house
@onready var fedor_effect: ColorRect = $fedor 

signal house_hurt

func _process(delta: float) -> void:
	vida.text = str(hp)
	progress_bar.value = hp

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.queue_free()
		
	house_hurt.emit()
	damage_house.play()
	await damage_house.finished
	hp -= 1
	if hp == 0:
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")

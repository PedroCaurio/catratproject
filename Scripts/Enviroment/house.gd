class_name House
extends StaticBody2D

var hp: int = 3
@onready var vida: Label = $Vida
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var damage_house: AudioStreamPlayer = $Damage_house
@onready var fedor_effect: ColorRect = $fedor 
@onready var casa: AnimatedSprite2D = $casa

signal house_hurt

func _process(delta: float) -> void:
	vida.text = str(hp)
	progress_bar.value = hp if hp > 0 else 0

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.queue_free()
		
	house_hurt.emit()
	damage_audio()
	hp -= 1
	$AnimationPlayer.play("dano")
	casa.play(str(hp))
	await get_tree().create_timer(0.8).timeout
	
	#if hp <= 0:
	#	get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")

func damage_audio():
	damage_house.play()
	print("Damage Audio")
	await damage_house.finished

class_name House
extends StaticBody2D

var hp: int = 3
@onready var vida: Label = $Vida
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var damage_house: AudioStreamPlayer2D = $Damage_house
@onready var fedor_effect: ColorRect = $fedor 


func _process(delta: float) -> void:
	vida.text = str(hp)
	progress_bar.value = hp

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.queue_free()
		
	activate_fedor_effect()
	damage_house.play()
	await damage_house.finished
	hp -= 1
	if hp == 0:
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")

func activate_fedor_effect() -> void:
	fedor_effect.visible = true
	
	var duration: float = 0.2
	await get_tree().create_timer(duration).timeout
	
	# 3. Desativa o efeito, tornando o ColorRect invisível novamente
	fedor_effect.visible = false
	
	# DICA: Se o seu shader tiver um parâmetro 'uniform' para o efeito,
	# você pode ajustar o código para:
	# fedor_effect.material.set_shader_param("fedor_intensity", 1.0)
	# ...
	# fedor_effect.material.set_shader_param("fedor_intensity", 0.0)

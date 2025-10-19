class_name Enemy
extends CharacterBody2D

var target_position: Vector2 
var speed:int =  800
var target 
func _process(delta: float) -> void:
	if target:
		# Pega a posição global do alvo em cada frame.
		# Isso garante que o nó seguirá o alvo mesmo que ele se mova.
		target_position = target.global_position
		
		# Calcula a distância até o alvo.
		var distance_to_target = global_position.distance_to(target_position)
		
		# Define uma pequena "zona morta" para evitar que o nó fique tremendo
		# ao chegar muito perto do alvo. Se a distância for menor que 5 pixels, pare.
		if distance_to_target > 5.0:
			# Pega o vetor de direção normalizado (comprimento 1) do nó até o alvo.
			var direction = global_position.direction_to(target_position)
			
			# Define a velocidade do corpo.
			velocity = direction * speed
		else:
			# Se estiver dentro da zona morta, para completamente.
			velocity = Vector2.ZERO
		
		# A função mágica que move o corpo e lida com colisões.
		move_and_slide()



	


func _on_hurtbox_body_entered(body: Node2D) -> void:
	queue_free()

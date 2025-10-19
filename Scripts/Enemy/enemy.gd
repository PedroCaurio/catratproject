class_name Enemy
extends CharacterBody2D

var target_position: Vector2 
var speed:int = 800
var target
var is_dead := false  # <- flag de morte
var attacking = false
@onready var sfx_rat_death: AudioStreamPlayer = $sfx_rat_death
@onready var animation_player: AnimationPlayer = $AnimationPlayer # Não usado no código, mas mantido

# CORREÇÃO: Preloade a cena de explosão (.tscn) e não apenas o script (.gdshader)
const EXPLOSION_SCENE = preload("res://Scenes/Explosion.tscn") # ASSUMIDO: Você precisa ter uma cena .tscn

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const COLLECTABLE = preload("res://Scenes/Enviroment/collectable.tscn")

signal enemy_killed

# O trecho de código abaixo estava fora de uma função e não rodaria corretamente:
# var e = e_scene.instantiate()
# get_parent().add_child(e)
# e.global_position = global_position
# AudioStreamPlayer.play("") 
# queue_free()

func _process(delta: float) -> void:
	# Se estiver morto, não faz mais nada
	if is_dead:
		return
	
	# ... (resto da função _process é mantido)
	if target:
		target_position = target.global_position
		var distance_to_target = global_position.distance_to(target_position)
		
		if distance_to_target > 5.0:
			var direction = global_position.direction_to(target_position)
			if not attacking:
				animated_sprite_2d.play("run")
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
			animated_sprite_2d.stop()
			# Este 'await' em _process pode causar problemas se o alvo mudar de estado rapidamente.
			# Considere usar Timer ou flag para controlar quando _process deve rodar a próxima animação.
			await animated_sprite_2d.animation_finished 
		
		var collision_info: KinematicCollision2D = move_and_collide(velocity * delta)
	
		if collision_info:
			
			if collision_info.get_collider() is House and not attacking:
				print(collision_info)

				attack_and_die(collision_info)
				
				
			velocity = velocity.bounce(collision_info.get_normal())
			
func attack_and_die(collision_info):
	attacking = true
	animated_sprite_2d.play("attack_rat")
	await animated_sprite_2d.animation_finished
	collision_info.get_collider().take_damage(self)
	queue_free()
	
func spawn_explosion():
	# 1. Instancia a cena de explosão
	var explosion = EXPLOSION_SCENE.instantiate()
	
	# 2. Adiciona a explosão como filho do pai do inimigo (a cena principal)
	get_parent().add_child(explosion)
	
	# 3. Coloca a explosão na posição exata do inimigo
	explosion.global_position = global_position
	
	# ASSUMIDO: A cena 'Explosion.tscn' tem um script que inicia os efeitos (partículas, luz, som)
	# e se destrói (queue_free) após a animação terminar.
	
func take_damage(body: Node2D) -> void:
	if is_dead:
		return
	

	if body.is_in_group("projectile"):
		is_dead = true            # <- impede o _process de rodar
		velocity = Vector2.ZERO    # <- para o movimento imediatamente
		enemy_killed.emit()
		
		# ⚠️ CHAME A FUNÇÃO DA EXPLOSÃO AQUI!
		spawn_explosion()
		
		# Inicia a animação de morte do inimigo. O inimigo será removido
		# quando a animação terminar (pela função _on_animated_sprite_2d_animation_finished).
		animated_sprite_2d.play("death_rat")
		sfx_rat_death.play()
	else:
		pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "death_rat":
		queue_free()

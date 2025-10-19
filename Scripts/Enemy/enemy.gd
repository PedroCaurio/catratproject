class_name Enemy
extends CharacterBody2D

var target_position: Vector2 
var speed:int = 800
var target
var is_dead := false  # <- flag de morte
var attacking = false
@onready var sfx_rat_death: AudioStreamPlayer = $sfx_rat_death
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const COLLECTABLE = preload("res://Scenes/Enviroment/collectable.tscn")

signal enemy_killed

func _process(delta: float) -> void:
	# Se estiver morto, não faz mais nada
	if is_dead:
		return
	
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
func take_damage(body: Node2D) -> void:
	if is_dead:
		return
	if randf() < 0.3:
		var moeda_mt_foda = COLLECTABLE.instantiate()
		get_parent().add_child(moeda_mt_foda)
		moeda_mt_foda.global_position = global_position
	if body.is_in_group("projectile"):
		is_dead = true                     # <- impede o _process de rodar
		velocity = Vector2.ZERO            # <- para o movimento imediatamente
		enemy_killed.emit()
		animated_sprite_2d.play("death_rat")
		sfx_rat_death.play()
	else:
		pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "death_rat":
		queue_free()

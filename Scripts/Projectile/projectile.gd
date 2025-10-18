# Projectile.gd
extends CharacterBody2D

signal collected

enum State_enum { MOVING, IDLE, RETURNING }

# --- PARÂMETROS DE FÍSICA (NOVOS) ---
# Atrito constante (resistência do ar). Reduz a velocidade em X pixels/segundo.
@export var linear_drag: float = 80.0 
# Fator de perda de velocidade ao colidir (0.0 = para totalmente, 1.0 = sem perda).
@export var bounce_friction_factor: float = 0.8 
# Velocidade mínima para o projétil parar e se tornar coletável.
@export var min_speed_to_stop: float = 30.0
var speed = 600
# --- REFERÊNCIAS E VARIÁVEIS ---
@onready var collectible_area: Area2D = $Area2D

var _current_state: State_enum = State_enum.MOVING

func _ready() -> void:
	add_to_group("collectible")
	collectible_area.monitoring = false

func _physics_process(delta: float) -> void:
	match _current_state:
		State_enum.MOVING:
			_process_movement_and_collision(delta)
		State_enum.RETURNING:
			# Lógica de retorno (se houver) entraria aqui.
			pass
		State_enum.IDLE:
			# Não faz nada quando está parado.
			pass

# Função principal que agora lida com toda a lógica de movimento e física.
func _process_movement_and_collision(delta: float) -> void:
	# 1. Aplica o atrito linear (resistência do ar)
	# move_toward é perfeito para reduzir a velocidade de forma constante e frame-independente.
	velocity = velocity.move_toward(Vector2.ZERO, linear_drag * delta)
	
	# 2. Verifica se a velocidade caiu abaixo do nosso limite para parar.
	if velocity.length() < min_speed_to_stop:
		_change_state_to_idle()
		return # Para a execução desta função para não mover o projétil neste frame.
		
	# 3. Move o corpo e verifica se houve colisão.
	var collision_info: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision_info:
		# 4. Se colidiu, reflete a direção e aplica o atrito de colisão.
		velocity = velocity.bounce(collision_info.get_normal())
		velocity *= bounce_friction_factor # Reduz a magnitude (velocidade) após o ricochete.

# (NOVA FUNÇÃO) Impulsiona o projétil com um vetor de força.
func boost_projectile(force_vector: Vector2) -> void:
	# Apenas impulsiona se o projétil estiver em movimento.
	if _current_state == State_enum.MOVING:
		velocity += force_vector

# (FUNÇÃO ALTERADA) A transição para IDLE permanece a mesma.
func _change_state_to_idle() -> void:
	_current_state = State_enum.IDLE
	velocity = Vector2.ZERO
	set_collision_mask_value(1, false)
	collectible_area.monitoring = true

# (FUNÇÃO INALTERADA) A coleta permanece a mesma.
func collect() -> void:
	emit_signal("collected")
	queue_free()

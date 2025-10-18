extends CharacterBody2D

# Sinal que será emitido quando o jogador coletar o projétil.
signal collected

# Enum para controlar o estado do projétil.
enum State_enum { MOVING, IDLE }

# --- EXPORTS E VARIÁVEIS ---
@export var speed: float = 700.0
@export var max_bounces: int = 1 # Quantas vezes pode ricochetear antes de parar.
@onready var collectible_area: Area2D = $Area2D

var _bounces_left: int
var _current_state: State_enum = State_enum.MOVING

func _ready() -> void:
	_bounces_left = max_bounces
	print("projectile criado")
	# O projétil deve poder ser detectado por um Area2D do jogador quando estiver parado.
	# Para isso, vamos adicioná-lo ao grupo "collectible".
	add_to_group("collectible")
	collectible_area.monitoring = false

func _physics_process(delta: float) -> void:
	# Só processa o movimento se estiver no estado MOVING.
	if _current_state == State_enum.MOVING:
		move_and_bounce(delta)

func move_and_bounce(delta: float) -> void:
	var collision_info: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision_info:
		# Reflete a velocidade para criar o ricochete.
		velocity = velocity.bounce(collision_info.get_normal())
		_bounces_left -= 1
		
		# Se os ricochetes acabaram, muda o estado para IDLE.
		if _bounces_left < 0:
			_change_state_to_idle()

# Função que transiciona o projétil para o estado parado/coletável.
func _change_state_to_idle() -> void:
	_current_state = State_enum.IDLE
	velocity = Vector2.ZERO # Para o movimento completamente.
	
	# Desativa a máscara de colisão para que ele não interaja mais com paredes/inimigos.
	# Isso evita que ele fique preso ou seja empurrado após parar.
	set_collision_mask_value(1, false) # Desativa colisão com layer 1 (paredes)
	# Se tiver uma layer para inimigos, desative-a também:
	# set_collision_mask_value(NUMERO_DA_LAYER_INIMIGO, false)
	collectible_area.monitoring = true

# Esta função será chamada pelo Player quando ele coletar o projétil.
func collect() -> void:
	emit_signal("collected") # Emite o sinal para o Player saber que foi coletado.
	queue_free() # Destrói o projétil.

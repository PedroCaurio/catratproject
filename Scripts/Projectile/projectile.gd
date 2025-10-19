# Projectile.gd
extends CharacterBody2D

signal collected

enum State_enum { MOVING, IDLE, RETURNING }

# --- PARÂMETROS DE FÍSICA ---
@export var linear_drag: float = 20.0
@export var bounce_friction_factor: float = 0.9
@export var min_speed_to_stop: float = 30.0
@export var return_speed: float = 5000.0 ## NOVO: Velocidade específica para o retorno.
@export var speed: float = 3500.0
# --- REFERÊNCIAS E VARIÁVEIS ---ds da
@onready var collectible_area: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _current_state: State_enum = State_enum.MOVING
var player: Player ## NOVO: Referência para o jogador que atirou.

func _ready() -> void:
	add_to_group("collectible")
	collectible_area.monitoring = false

	

## NOVO: Função de inicialização para passar a referência do jogador.
# Esta é a prática correta de Injeção de Dependência em POO.
func init(shooter: CharacterBody2D) -> void:
	player = shooter

func _physics_process(delta: float) -> void:
	match _current_state:
		State_enum.MOVING:
			_process_movement_and_collision(delta)
		State_enum.RETURNING:
			_process_return_movement(delta) ## ALTERADO: Chamamos a nova função.
		State_enum.IDLE:
			pass

## NOVO: Função que lida com o movimento de retorno.
func _process_return_movement(delta: float) -> void:
	# Verificação de segurança: Se o jogador não existir mais, o projétil para.
	if not is_instance_valid(player):
		_change_state_to_idle()
		return
	
	# Calcula a direção até o jogador e define a velocidade.
	var direction_to_owner = global_position.direction_to(player.global_position)
	velocity = direction_to_owner * return_speed
	
	var collision_info = move_and_collide(velocity * delta)
	
	# Se colidir com algo (uma parede), para de se mover e fica coletável.
	if collision_info:
		_change_state_to_idle()

# Função principal que agora lida com toda a lógica de movimento e física.
func _process_movement_and_collision(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, linear_drag * delta)
	
	if velocity.length() < min_speed_to_stop:
		_change_state_to_idle()
		return
		
	var collision_info: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision_info:
		if collision_info.get_collider() is Enemy:
			collision_info.get_collider().take_damage(self)
		velocity = velocity.bounce(collision_info.get_normal())
		velocity *= bounce_friction_factor

# (NOVA FUNÇÃO) Impulsiona o projétil com um vetor de força.
func boost_projectile(force_vector: Vector2) -> void:
	if _current_state == State_enum.MOVING:
		velocity += force_vector
		
## NOVO: Função pública para o jogador chamar e iniciar o retorno.
func recall_projectile() -> void:
	# Só pode ser chamado se estiver em movimento ou parado.
	if _current_state == State_enum.MOVING or _current_state == State_enum.IDLE:
		_current_state = State_enum.RETURNING
		# Garante que ele não possa ser coletado enquanto retorna.
		collectible_area.monitoring = false
		# Reativa a máscara de colisão com paredes, caso estivesse desativada no estado IDLE.
		set_collision_mask_value(1, true)

func _change_state_to_idle() -> void:
	_current_state = State_enum.IDLE
	velocity = Vector2.ZERO
	set_collision_mask_value(1, false)
	collectible_area.monitoring = true

func collect() -> void:
	emit_signal("collected")
	queue_free()

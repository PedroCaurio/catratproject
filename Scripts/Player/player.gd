class_name Player
extends CharacterBody2D
@onready var recalls: Label = $Recalls

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $StateMachine
@onready var state: Label = $State
@export var speed := 4000.0
@export var max_ammo := 1  
@export var projectile_scene: PackedScene
@export var spawn_offset:= 600.0
@export var preview_max_range := 1000.0 # O alcance máximo da pré-visualização.
@export var current_recall: = true
var current_ammo: int
var projectile_instance: CharacterBody2D = null
@onready var muzzle := $ShootPoint
#@onready var muzzle: Marker2D = $Collector/ShootPoint
@onready var color_rect: ColorRect = $ColorRect
@onready var trajectory_preview: Line2D = $TrajectoryPreview 
@onready var aim_raycast: RayCast2D = $AimRayCast           
@onready var bola: AnimatedSprite2D = $bola
signal shooted
# --- STATE MACHINE FUNCTIONS ---
func _ready() -> void:
	state_machine.init(self)
	current_ammo = max_ammo

	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("recall_projectile") and projectile_instance and current_recall:
		current_ammo -= 1
		projectile_instance.recall_projectile()
		current_recall = false
		shooted.emit()
	state_machine.process_input(event)
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	state.text = state_machine.current_state.name
	recalls.text = str(current_recall)
	color_rect.global_position = get_global_mouse_position()
	muzzle.look_at(get_global_mouse_position())
	_update_trajectory_preview()

# --- FUNÇOES ATIVAS ---
func shoot() -> void:
	# Verifica se tem munição e se a cena do projétil está configurada.
	if current_ammo <= 0 or not projectile_scene:
		# Opcional: tocar um som de "sem munição".
		return
	
	current_ammo -= 1
	hide_aim()
	
	projectile_instance = projectile_scene.instantiate()
	projectile_instance.player = self
	var direction = Vector2.RIGHT.rotated(muzzle.global_rotation)
	var spawn_position = global_position + (direction * spawn_offset)
	
	get_tree().root.add_child(projectile_instance)
	
	# 5. Define a posição e rotação calculadas.
	projectile_instance.global_position = spawn_position
	projectile_instance.rotation = muzzle.global_rotation # A rotação continua vindo do muzzle.
	
	# 6. Define a velocidade do projétil usando a mesma direção.
	projectile_instance.velocity = direction * projectile_instance.speed

# Funçoes reativas
func hide_aim():
	trajectory_preview.hide()
	bola.hide()

func show_aim():
	trajectory_preview.show()
	bola.show()
	
func _update_trajectory_preview() -> void:
	# 1. O ponto de início é SEMPRE a posição global do muzzle.
	var start_point = muzzle.global_position
	
	# 2. A direção também parte do muzzle para o mouse.
	var direction = start_point.direction_to(get_global_mouse_position())
	
	# 3. Configura o RayCast a partir da posição do muzzle.
	aim_raycast.global_position = start_point
	aim_raycast.target_position = direction * preview_max_range
	aim_raycast.force_raycast_update()
	
	# 4. Determina o ponto final global.
	var end_point: Vector2
	if aim_raycast.is_colliding():
		end_point = aim_raycast.get_collision_point()
	else:
		end_point = start_point + direction * preview_max_range
		
	# 5. Limpa e adiciona os pontos convertidos para o espaço local do Line2D.
	# Esta parte já estava quase certa, mas agora a origem (start_point) é mais confiável.
	trajectory_preview.clear_points()
	trajectory_preview.add_point(trajectory_preview.to_local(start_point))
	trajectory_preview.add_point(trajectory_preview.to_local(end_point))

func give_recall():
	current_recall = true

func _on_collector_area_entered(area: Area2D) -> void:
	# Verifica se a área que entrou pertence a um projétil coletável.
	if area.get_parent().is_in_group("collectible"):
		# A área é filha do projétil, então chamamos a função no pai.
		var projectile = area.get_parent()
		
		# Verifica se a função 'collect' existe antes de chamar, por segurança.
		if projectile.has_method("collect"):
			projectile.collect()
			
			# Incrementa a munição, garantindo que não ultrapasse o máximo.
			current_ammo = 1
			show_aim()

func normal_speed():
	speed = 2000.0
	
func slow():
	speed = 1000.0
	
func _on_hurtbox_body_entered(body: Node2D) -> void:
	state_machine.take_damage()

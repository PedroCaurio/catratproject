class_name Player
extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $StateMachine
@onready var state: Label = $State
@export var speed := 200.0
@export var max_ammo := 1
@export var projectile_scene: PackedScene
@export var spawn_offset:= 100.0

var current_ammo: int

@onready var muzzle := $ShootPoint
#@onready var muzzle: Marker2D = $Collector/ShootPoint


# --- STATE MACHINE FUNCTIONS ---
func _ready() -> void:
	state_machine.init(self)
	current_ammo = max_ammo
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	state.text = state_machine.current_state.name
	
	muzzle.look_at(get_global_mouse_position())

# --- FUNÇOES ATIVAS ---
func shoot() -> void:
	# Verifica se tem munição e se a cena do projétil está configurada.
	if current_ammo <= 0 or not projectile_scene:
		# Opcional: tocar um som de "sem munição".
		print("Sem munição!")
		return
		
	current_ammo -= 1
	print("Munição: ", current_ammo)
	
	var projectile_instance: CharacterBody2D = projectile_scene.instantiate()
	var direction = Vector2.RIGHT.rotated(muzzle.global_rotation)
	var spawn_position = global_position + (direction * spawn_offset)
	get_tree().root.add_child(projectile_instance)
	
	# 5. Define a posição e rotação calculadas.
	projectile_instance.global_position = spawn_position
	projectile_instance.rotation = muzzle.global_rotation # A rotação continua vindo do muzzle.
	
	# 6. Define a velocidade do projétil usando a mesma direção.
	projectile_instance.velocity = direction * projectile_instance.speed

# Funçoes reativas




func _on_collector_area_entered(area: Area2D) -> void:
	# Verifica se a área que entrou pertence a um projétil coletável.
	if area.get_parent().is_in_group("collectible"):
		# A área é filha do projétil, então chamamos a função no pai.
		var projectile = area.get_parent()
		
		# Verifica se a função 'collect' existe antes de chamar, por segurança.
		if projectile.has_method("collect"):
			projectile.collect()
			
			# Incrementa a munição, garantindo que não ultrapasse o máximo.
			current_ammo = min(current_ammo + 1, max_ammo)
			print("Munição recuperada! Total: ", current_ammo)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	state_machine.take_damage()

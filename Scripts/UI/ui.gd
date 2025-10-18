class_name ui
extends Control
@onready var money: Label = $Money
@onready var ammo_1: TextureRect = $HBoxContainer/Ammo1
@onready var ammo_2: TextureRect = $HBoxContainer/Ammo2
@onready var ammo_3: TextureRect = $HBoxContainer/Ammo3
@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var time: Label = $Time


var money_couter : int = 0
var ammo_couter : int = 3


func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	pass


func update_money(addicional: int):
	money_couter += addicional
	money.text = ""

func update_time(actual_time: String):
	time.text = actual_time
	
func add_ammo():
	if ammo_couter < 3:
		ammo_couter += 1
	var index = 0
	for child in  h_box_container.get_children():
		if index < ammo_couter:
			child.show()
		else:
			child.hide()
		index += 1
			
func consume_ammo():
	if ammo_couter > 0:
		ammo_couter -= 1
	var index = 0
	for child in  h_box_container.get_children():
		if index < ammo_couter:
			child.show()
		else:
			child.hide()
		index += 1

extends InteractComponent

@onready var vending_models = preload("res://objects/object_models/vending_machines/vm1_pbear.tres")
@onready var vending_models1 = preload("res://objects/object_models/vending_machines/vm2_pauler.tres")
@onready var vending_models2 = preload("res://objects/object_models/vending_machines/vm3_pooch.tres")
@onready var vending_models4 = preload("res://objects/object_models/vending_machines/vm5_booshido.tres")
@onready var vending_models5 = preload("res://objects/object_models/vending_machines/vm6_BNBB.tres")
@onready var vending_models6 = preload("res://objects/object_models/vending_machines/vm7_EAJ.tres")

@export_enum("Pbear", "Pauler", "PoochBrew", "BooshidoTea", "BNBB", "EAJ") var VendingMachineType: int
@onready var player = $".."
@onready var output_marker = $"../OutputMarker"
@onready var output_direction = $"../OutputDirection"
@onready var vending_model

func _ready() -> void:
	match VendingMachineType:
		0:
			# P-bear pop
			print("loaded in p-bear pop")
			get_parent().add_child.call_deferred(vending_models.model.instantiate())
			vending_model = vending_models
		1:
			# Pauler re-charge
			print("loaded in pauler re-charge")
			get_parent().add_child.call_deferred(vending_models1.model.instantiate())
			vending_model = vending_models1
		2:
			# Pooch brew
			print("loaded in pooch brew")
			get_parent().add_child.call_deferred(vending_models2.model.instantiate())
			vending_model = vending_models2
		3:
			pass
		4:
			# Booshido green tea
			print("loaded in booshido tea")
			get_parent().add_child.call_deferred(vending_models4.model.instantiate())
			vending_model = vending_models4
		5:
			# BNBB
			print("loaded in BNBB")
			get_parent().add_child.call_deferred(vending_models5.model.instantiate())
			vending_model = vending_models5
		6:
			# Edd's ape juice
			print("loaded in EAJ")
			get_parent().add_child.call_deferred(vending_models6.model.instantiate())
			vending_model = vending_models6

	# p-bear pop: health +
	# pauler re-charge: movement speed +
	# pooch brew: health regen
	# booshido green tea: reload speed +
	# beard n' bark brew: ?
	# edd's ape juice: max health +


func Interact():
	print("Interact")
	#Audio.play(model.interact_sound)
	print("vendy boi")
	var item_to_drop = vending_model.output.instantiate()
	player.get_parent().add_child(item_to_drop)
	print("added" + str(item_to_drop))
	item_to_drop.position = output_marker.global_position
	print(item_to_drop.get_position())
	var direction = (output_direction.global_transform.origin - global_transform.origin).normalized()
	item_to_drop.apply_impulse(direction * 2.5)
	item_to_drop.rotate(basis.x, 90)

func _on_button_button_pressed_parent() -> void:
	print("we did it boys")
	Interact()

func _on_button_2_button_pressed_parent() -> void:
	Interact()

func _on_button_3_button_pressed_parent() -> void:
	Interact()

func _on_button_4_button_pressed_parent() -> void:
	Interact()

func _on_button_5_button_pressed_parent() -> void:
	Interact()

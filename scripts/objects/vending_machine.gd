extends Resource
class_name VendingMachine

@export_category("Interaction Type")
@export var object_name: String  # Name of object
@export var model: PackedScene
@export var output: PackedScene

@export_subgroup("Sounds")
@export var sound_shoot: String  # Object sound path
@export var interact_sound: String  # Object interact sound path



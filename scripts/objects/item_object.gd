extends Resource
class_name ItemObject

@export_category("Interaction Type")
@export var object_number: int  # Number of object
@export var object_name: String  # Name of object

@export var interact: bool  # Interaction
@export var pick_up: bool  # Pick up
@export var object_static: bool # Static none interactable

@export_subgroup("Sounds")
@export var sound_shoot: String  # Object sound path
@export var interact_sound: String  # Object interact sound path



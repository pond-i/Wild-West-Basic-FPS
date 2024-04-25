extends Resource
class_name Weapon

@export_category("Interaction Type")
@export var object_number: int  # Number of object
@export var object_name: String  # Name of object
@export var interact: bool  # Interaction
@export var pick_up: bool  # Pick up

@export_subgroup("Model")
@export var weapon_name: String  # Name of the weapon
@export var model: PackedScene  # Model of the weapon
@export var position: Vector3  # On-screen position
@export var rotation: Vector3  # On-screen rotation
@export var muzzle_position: Vector3  # On-screen position of muzzle flash
@export var viewable_muzzle: bool  # On-screen position of muzzle flash toggle

@export_subgroup("Melee")
@export var melee: bool  # Is melee

@export_subgroup("Mechanics")
@export var limited_rounds: bool # Has limited rounds
@export var clip_ammo: int # Clip count
@export var total_ammo: int # Total count
@export var read_only_max_ammo: int # Read only maximum ammo per clip
@export var animation_speed: float # Animation count
@export var reload_speed: float # Reload Speed
@export var reload_cooldown: float # Reload cd

@export_subgroup("Properties")
@export_range(0.1, 22) var cooldown: float = 0.1  # Firerate
@export_range(1, 1000) var max_distance: int = 10  # Fire distance
@export_range(0, 1000) var damage: float = 25  # Damage per hit
@export_range(0, 5) var spread: float = 0  # Spread of each shot
@export_range(1, 5) var shot_count: int = 1  # Amount of shots
@export_range(-10000, 10000) var knockback: int = 20  # Amount of knockback

@export_subgroup("Crosshair")
@export var crosshair: Texture2D  # Image of crosshair on-screen

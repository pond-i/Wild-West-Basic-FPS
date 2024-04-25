extends Area3D

@export var enemy: Enemy
@export var moving = false
@export var hit: String
@export var image: Texture2D

@onready var anime = $AnimationPlayer
@onready var timer = $Timer	
@onready var logger = %DebugLabel

func _ready() -> void:
	$Marker3D/Sprite3D.set_texture(image)

func Hover():
	return enemy

func Log(text):
	logger.append_text("\n" + text)

func damage(amount):
	Log("Hit for: " + str(amount))
	anime.play("Bonk")
	$CollisionShape3D.disabled = true
	Audio.play("sounds/WeaponImpact/impact1.wav, sounds/WeaponImpact/impact2.wav, sounds/WeaponImpact/impact3.wav")
	timer.start(2)

func _on_timer_timeout() -> void:
	$CollisionShape3D.disabled = false
	anime.play_backwards("Bonk")
	

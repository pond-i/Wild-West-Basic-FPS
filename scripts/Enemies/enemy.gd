extends Node3D

@export var player: Node3D
@export var enemy: Enemy
@export var attack: bool

@onready var raycast = $RayCast
@onready var muzzle_a = $MuzzleA
@onready var muzzle_b = $MuzzleB

var health := 100
var time := 0.0
var target_position: Vector3
var destroyed := false
@onready var logger = %DebugLabel
# When ready, save the initial 

func Hover():
	return enemy

func _ready():
	target_position = position


func _process(delta):
	self.look_at(player.position + Vector3(0, 0.5, 0), Vector3.UP, true)  # Look at player
	target_position.y += (cos(time * 5) * 1) * delta  # Sine movement (up and down)

	time += delta

	position = target_position


# Take damage from player


func damage(amount):
	Audio.play("sounds/enemy_hurt.ogg")

	health -= amount
	Log("Hit for: " + str(amount))
	
	if health <= 0 and !destroyed:
		destroy()
		
func Log(text):
	logger.append_text("\n" + text)


# Destroy the enemy when out of health

func destroy():
	Audio.play("sounds/enemy_destroy.ogg")

	destroyed = true
	queue_free()


# Shoot when timer hits 0


func _on_timer_timeout():
	raycast.force_raycast_update()

	if raycast.is_colliding() and attack:
		var collider = raycast.get_collider()

		if collider.has_method("Damage"):  # Raycast collides with player
			print(collider)
			print("Attacking")
			# Play muzzle flash animation(s)

			muzzle_a.frame = 0
			muzzle_a.play("default")
			muzzle_a.rotation_degrees.z = randf_range(-45, 45)

			muzzle_b.frame = 0
			muzzle_b.play("default")
			muzzle_b.rotation_degrees.z = randf_range(-45, 45)

			Audio.play("sounds/enemy_attack.ogg")

			collider.Damage(5)  # Apply damage to player

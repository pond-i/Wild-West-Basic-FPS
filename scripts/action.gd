extends Node3D

@export_subgroup("Weapons")
@export var weapons: Array[Weapon] = []

#var messages = {
#	0: "",
#	1: "Interact 'F'",
#	2: "Pick Up 'F'"
#}

var container_offset = Vector3(1.2, -1.1, -2.75)
var interaction_state = null

var weapon: Weapon
var current_weapon = null
var weapon_model = null
var weapon_index := 0
var weapon_clip_ammo := 0
var weapon_max_ammo := 0
var is_ADS = false
var weapon_animation: AnimationPlayer
var is_reloading: bool
var crosshair_default = preload("res://sprites/crosshair.png")
var hit_crosshair = preload("res://sprites/crosshair-repeater.png")
var hit_crosshair_interact = preload("res://sprites/crosshair_interact.png")

var current_object_hover = null
var tween:Tween

@onready var player = $".."
@onready var anime = $Camera/SubViewportContainer/SubViewport/CameraItem/Anime
@onready var fire_ray_cast = $Camera/RayCast
@onready var interact_ray_cast = $Camera/InteractCast
@onready var muzzle = $Camera/SubViewportContainer/SubViewport/CameraItem/Muzzle
@onready var container = $Camera/SubViewportContainer/SubViewport/CameraItem/Container
@onready var camera = $Camera
@onready var head = $"."
@onready var sound_footsteps = $SoundFootsteps
@onready var weapon_cooldown = $Cooldown
@onready var weapon_reload_cooldown = $ReloadCooldown
@onready var muzzle_flash = $ShotLight
@onready var crosshair: TextureRect

# HUD
@onready var logger = $"../../HUD/DebugLabel"
@onready var weapon_name_label = $"../../HUD/WeaponInfo/WeaponLabel"
@onready var weapon_ammo_label = $"../../HUD/WeaponInfo/Ammo"
@onready var weapon_total_ammo_label = $"../../HUD/WeaponInfo/AmmoTotal"
@onready var interaction_label = $"../../HUD/InteractionMenu"
@onready var crosshair_hud = $"../../HUD/Crosshair"

func _ready() -> void:
	crosshair = player.crosshair
	weapon = weapons[weapon_index] # Weapon must never be nil
	if (weapons.size() == 0):
		weapons.append(Items.items_hand[0])
	InitiateChangeWeapon(weapon_index)
	interaction_state = "NONE"

func ActionReload():
	if Input.is_action_just_pressed("Reload"):
		if(weapon.object_number == 0): return
		if !weapon_cooldown.is_stopped(): return
		
		var weapon_anime = weapon_model.get_node_or_null("AnimationPlayer")
		if(weapon_anime.is_playing()): return
		
		if(weapon.clip_ammo == weapon.read_only_max_ammo): return
		
		if(weapon.total_ammo != 0 and weapon.total_ammo >= weapon.read_only_max_ammo):
			if(weapon.total_ammo >= weapon.read_only_max_ammo):
				weapon.clip_ammo = weapon.read_only_max_ammo
				weapon.total_ammo -= weapon.read_only_max_ammo

				if(weapon_anime):
					weapon_anime.speed_scale = weapon.reload_speed
					weapon_anime.play("Reload")
					weapon_reload_cooldown.start(weapon.reload_cooldown)
		
# Shooting

func ActionShoot():
	if(weapon.object_number == 0): return
	
	if Input.is_action_just_pressed("shoot"):
			
		if !weapon_cooldown.is_stopped(): return # Cooldown for shooting
		if !weapon_reload_cooldown.is_stopped(): return # Cooldown for reloading
		var weapon_anime = weapon_model.get_node_or_null("AnimationPlayer")
		if(weapon_anime.is_playing()): return
		
		if(weapon.melee):
			anime.play_backwards("Swing")
		else:
			if(weapon_model.get_node_or_null("AnimationPlayer")):
				if(weapon.clip_ammo <= weapon.read_only_max_ammo and weapon.clip_ammo > 0):
					ActionFire()
				else:
					weapon_anime.play("Slide")
		
func ActionFire():
	# Fire animation
	var weapon_anime = weapon_model.get_node_or_null("AnimationPlayer")
	if(weapon_anime.is_playing()): return
	weapon_anime.speed_scale = weapon.animation_speed
	weapon_anime.play("Fire")
	weapon.clip_ammo = weapon.clip_ammo - 1
	if(weapon.object_number == 3):
		DropItem()
	# Apply knockback
	
	container.position.z += 0.25 # Knockback of weapon visual
	camera.rotation.x += 0.025 # Knockback of camera
	player.KnockBack(weapon.knockback)
	
	if(weapon.viewable_muzzle):
		muzzle.play("default")
		muzzle.rotation_degrees.z = randf_range(-45, 45)
		muzzle.scale = Vector3.ONE * randf_range(0.40, 0.75)
		muzzle.position = container.position - weapon.muzzle_position

		weapon_cooldown.start(weapon.cooldown)

	# Shoot the weapon, amount based on shot count

	for n in weapon.shot_count:
		fire_ray_cast.target_position.x = randf_range(-weapon.spread, weapon.spread)
		fire_ray_cast.target_position.y = randf_range(-weapon.spread, weapon.spread)
		
		fire_ray_cast.force_raycast_update()
		
		if !fire_ray_cast.is_colliding(): continue # Don't create impact when raycast didn't hit
		
		if(weapon.melee):
			Audio.play(weapon.sound_shoot)
			
		var collider = fire_ray_cast.get_collider()
		
		# Hitting an enemy
		
		if collider.has_method("damage"):
			collider.damage(weapon.damage)
		
		# Creating an impact animation
		
		var impact = preload("res://objects/impact.tscn")
		var impact_instance = impact.instantiate()
		
		impact_instance.play("shot")
		
		get_tree().root.add_child(impact_instance)
		var camera_direction = -self.get_global_transform().basis.z
		print(fire_ray_cast.get_collider())
		if(fire_ray_cast.get_collider().is_in_group("canMove")):
			var body = fire_ray_cast.get_collider().get_parent()
			if body is RigidBody3D:
				body.apply_central_impulse(camera_direction * weapon.knockback)
		crosshair.texture = hit_crosshair
		impact_instance.position = fire_ray_cast.get_collision_point() + (fire_ray_cast.get_collision_normal() / 10)
		impact_instance.look_at(camera.global_transform.origin, Vector3.UP, true)
		muzzle_flash.show()
		await get_tree().create_timer(.2).timeout
		muzzle_flash.hide()
		crosshair.texture = weapon.crosshair
		

func AimDownSight():
	
	if Input.is_action_just_pressed("Right_click"):
		anime.play("Aim_down_sight")

# Toggle between available weapons (listed in 'weapons')

func ActionWeaponToggle():
	
	if Input.is_action_just_pressed("weapon_toggle"):
		WeaponSwap()

func ActionDropItem():
	
	if Input.is_action_just_pressed("drop"):
		DropItem()

func ActionInteract(hovered_component):
	match hovered_component.LabelType:
		0:
			pass
		# Interact
		1:
			if Input.is_action_just_pressed("Interact"):
				hovered_component.Interact.Interact()
		# Pick up
		2: 
			if Input.is_action_just_pressed("Interact"):
				var item_code = hovered_component.PickUp.PickUp()
				weapons.push_back(Items.items_hand[item_code])
				InitiateChangeWeapon(weapons.size() -1)

func WeaponSwap():
	weapon_index = wrap(weapon_index + 1, 0, weapons.size())
	InitiateChangeWeapon(weapon_index)
	
# Initiates the weapon changing animation (tween)

func InitiateChangeWeapon(index):
	
	weapon_index = index
	Audio.play("sounds/weapon_change.ogg")
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(container, "position", container_offset - Vector3(0, 1, 0), 0.1)
	tween.tween_callback(ChangeWeapon) # Changes the model
	

# Switches the weapon model (off-screen)

func DropItem():
	
	for i in range(weapons.size()):
		if weapons[i].weapon_name == current_weapon:
			if(weapon.object_number == 0): 
				WeaponSwap() 
				return
			weapons.pop_at(i)
			var item_to_drop = Items.items_floor[weapon.object_number].instantiate()
			player.get_parent().add_child(item_to_drop)
			print("added" + str(item_to_drop) + "to" + str(get_parent()))
			
			item_to_drop.position = head.global_position - Vector3(0, 0.5, 0)
			print(item_to_drop.get_position())
			
			var camera_direction = -self.get_global_transform().basis.z
			print(camera_direction)
			item_to_drop.apply_impulse(camera_direction * 5)
			item_to_drop.rotate(basis.x, 90)
#				ChangeWeapon()
			WeaponSwap()
			break
	
	player.Log("\ndropped weapon " + str(current_weapon))

func ChangeWeapon():
	
	if !weapons.is_empty():
		weapon = weapons[weapon_index]

	# Step 1. Remove previous weapon model(s) from container
	
	for n in container.get_children():
		container.remove_child(n)
	
	# Step 2. Place new weapon model in container

	weapon_model = weapon.model.instantiate()
	current_weapon = weapon.weapon_name
	weapon_name_label.set_text(current_weapon)
	
	container.add_child(weapon_model)
	
	weapon_model.position = weapon.position
	weapon_model.rotation_degrees = weapon.rotation
	
	# Step 3. Set model to only render on layer 2 (the weapon camera)
	
	for child in weapon_model.find_children("*", "MeshInstance3D"):
		child.layers = 2
		
	# Set weapon data
	
	fire_ray_cast.target_position = Vector3(0, 0, -1) * weapon.max_distance
	#crosshair.texture = weapon.crosshair

func HudUpdate():
	weapon_ammo_label.set_text(str(weapon.clip_ammo))
	weapon_total_ammo_label.set_text(str(weapon.total_ammo))

func RaycastHover():
	if interact_ray_cast.is_colliding():
		# print(interact_ray_cast.get_collider())
		if (interact_ray_cast.get_collider() == null): return
		LabelUpdate()
			
func LabelUpdate():
	if interact_ray_cast.get_collider() is LabelComponent:
		var hovered_component: LabelComponent = interact_ray_cast.get_collider()
		var returned_label = hovered_component.Hover()
		UpdateInteractionLabel(returned_label)
		crosshair.texture = hit_crosshair_interact
		if(hovered_component.LabelType != 0):
			ActionInteract(hovered_component)
	else:
		interaction_label.set_visible(false)	
		crosshair.texture = weapon.crosshair	

func InteractionState(model):
	if(model.return_function == "AmmoBox"):
		interaction_state = "AMMO"
	
	if(model.pick_up == true):
		interaction_state = "PICKUP"

func UpdateInteractionLabel(text):
	interaction_label.set_text(text)
	interaction_label.set_visible(true)

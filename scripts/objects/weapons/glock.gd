extends Node3D

@export var glock_empty: String
@export var glock_fire: String
@export var glock_slider: String
@export var glock_shell: String
@export var glock_mag: String
@export var glock_dry: String


signal animation_finished

func Fire():
	Audio.play(glock_fire)

func Empty():
	Audio.play(glock_empty)
	
func Slider():
	Audio.play(glock_slider)
	
func Shell():
	Audio.play(glock_shell)
	
func Mag():
	Audio.play(glock_mag)
	
func Dry():
	Audio.play(glock_dry)


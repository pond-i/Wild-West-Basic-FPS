extends Node3D

@export var fire_axe_empty: String
@export var fire_axe_fire: String
@export var fire_axe_cock: String
@export var fire_axe_cock_back: String
@export var fire_axe_shell: String
@export var fire_axe_mag: String
@export var fire_axe_fwump: String

func Fire():
	Audio.play(fire_axe_fire)

func Empty():
	Audio.play(fire_axe_empty)
	
func Cock():
	Audio.play(fire_axe_cock)
	
func CockBack():
	Audio.play(fire_axe_cock_back)
	
func Shell():
	Audio.play(fire_axe_shell)
	
func Mag():
	Audio.play(fire_axe_mag)
	
func Fwump():
	Audio.play(fire_axe_fwump)


extends Node3D

@export var double_barrel_empty: String
@export var double_barrel_fire: String
@export var double_barrel_cock: String
@export var double_barrel_cock_back: String
@export var double_barrel_shell: String
@export var double_barrel_mag: String
@export var double_barrel_fwump: String

func Fire():
	Audio.play(double_barrel_fire)

func Empty():
	Audio.play(double_barrel_empty)
	
func Cock():
	Audio.play(double_barrel_cock)
	
func CockBack():
	Audio.play(double_barrel_cock_back)
	
func Shell():
	Audio.play(double_barrel_shell)
	
func Mag():
	Audio.play(double_barrel_mag)
	
func Fwump():
	Audio.play(double_barrel_fwump)


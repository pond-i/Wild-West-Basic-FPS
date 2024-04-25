extends Node

@onready var cock_1 = "sounds/Spas/cock_1.mp3"
@onready var cock_2 = "sounds/Spas/cock_2.mp3"
@onready var load_shell = "sounds/Spas/load.mp3"
@onready var click = "sounds/Spas/empty.wav"
@onready var fire = "sounds/Spas/fire.mp3"
@onready var shell = "sounds/Spas/shell.wav"
@onready var stock_fold = "sounds/Spas/stock_fold1.wav"
@onready var stock_fold2 = "sounds/Spas/stock_fold2.wav"
@onready var anim = $AnimationPlayer

func _ready() -> void:
	anim.play("Intro")

func Cock_1():
	Audio.play(cock_1)

func Cock_2():
	Audio.play(cock_2)

func Load():
	Audio.play(load_shell)

func Click():
	Audio.play(click)
	
func Fire():
	Audio.play(fire)

func Shell():
	Audio.play(shell)
	
func Stock_fold():
	Audio.play(stock_fold)
	
func Stock_fold2():
	Audio.play(stock_fold2)


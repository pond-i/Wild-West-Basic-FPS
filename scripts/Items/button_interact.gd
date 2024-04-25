extends InteractComponent

@onready var anime = $"../AnimationPlayer"

signal ButtonPressed()

func Interact():
	ButtonPressed.emit()
	print("Button has been pressed")
	anime.play("button_press")

func _ready() -> void:
	$"../LabelComponent".LabelName = $"..".ButtonName

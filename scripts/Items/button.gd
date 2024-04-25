extends Node3D

@export var ButtonName: String
signal ButtonPressedParent()

func _on_interact_component_button_pressed() -> void:
	ButtonPressedParent.emit()
	print("awoogy")

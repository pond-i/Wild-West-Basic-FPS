extends Node3D
class_name PickUpComponent

@export var item_code: int

func PickUp():
	print("Picked up")
	get_parent().Interact()
	get_parent().queue_free()
	return item_code

extends Area3D
class_name LabelComponent

@export var LabelName: String
@export_enum("None", "Interact", "PickUp") var LabelType: int
@export var PickUp: PickUpComponent
@export var Interact: InteractComponent

#func _ready() -> void:
#	if Interact == null:
#		LabelName = "no label found"
#	else:
#		Interact.model.object_name

var messages = {
	0: "",
	1: "Interact 'F' ",
	2: "Pick Up 'F' "
}

func Hover():
	var returned_message
	match LabelType:
		0:
			return
		1:
			returned_message = messages[1] + LabelName
			return returned_message
		2:
			returned_message = messages[2] + LabelName
			return returned_message
			

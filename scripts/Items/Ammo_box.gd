extends InteractComponent

@export var item: ItemObject
@onready var anime = $AnimationPlayer
@onready var interactive_timer = $Timer

func Hover():
	Open()
	return item

func Open():
	if !interactive_timer.is_stopped(): return
	interactive_timer.start(item.interaction_cool_down)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body.name == "Player"):
		anime.play("Open")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if(body.name == "Player"):
		anime.play_backwards("Open")

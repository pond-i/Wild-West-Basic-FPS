extends RigidBody3D

var item: ItemObject
	
func Interact():
	Audio.play(item.interact_sound)

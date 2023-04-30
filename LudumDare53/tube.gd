extends Node2D

func _ready():
	pass

func move(fromVec, toVec):
	var tween = get_node("Tween")
	tween.interpolate_property(
		self, "position",
		fromVec, toVec, 
		4
	)
	tween.start()

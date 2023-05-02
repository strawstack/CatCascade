extends Node2D

var doors = []

func _ready():
	doors.push_back($door0)
	doors.push_back($door1)
	doors.push_back($door2)
	doors.push_back($door3)

func doorChange(doorNumber, isClosed):
	var door = doors[doorNumber]
	
	if isClosed:
		door.get_node("open").visible  = false
		door.get_node("close").visible = true
		
	else:
		door.get_node("open").visible  = true
		door.get_node("close").visible = false

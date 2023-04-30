extends Node

var switchState = {
	"q": 0,
	"w": 0,
	"e": 0,
	"r": 0,
	
	"a": 0,
	"s": 0,
	"d": 0,
	"f": 0,
}

# init by _ready()
var switches = { 
	"q": null,
	"w": null,
	"e": null,
	"r": null,
	
	"a": null,
	"s": null,
	"d": null,
	"f": null,
}

var arrows = {
	"q": null,
	"w": null,
	"e": null,
	"r": null,
	
	"a": null,
	"s": null,
	"d": null,
	"f": null,
}

var switchRot = {
	"q": [0, 180],
	"w": [90, 180],
	"e": [90, 180],
	"r": [90, 180],
	
	"a": [180, 270],
	"s": [0, 270],
	"d": [180, 270],
	"f": [180, 270],
}

func _ready():
	switches["q"] = $switches/qSwitch
	switches["w"] = $switches/wSwitch
	switches["e"] = $switches/eSwitch
	switches["r"] = $switches/rSwitch
	
	switches["a"] = $switches/aSwitch
	switches["s"] = $switches/sSwitch
	switches["d"] = $switches/dSwitch
	switches["f"] = $switches/fSwitch

	arrows["q"] = $arrows/qArrow
	arrows["w"] = $arrows/wArrow
	arrows["e"] = $arrows/eArrow
	arrows["r"] = $arrows/rArrow
	
	arrows["a"] = $arrows/aArrow
	arrows["s"] = $arrows/sArrow
	arrows["d"] = $arrows/dArrow
	arrows["f"] = $arrows/fArrow
	
	for switchKey in "qwerasdf":
		var newDegrees = switchRot[switchKey][switchState[switchKey]]
		switches[switchKey].set_rotation_degrees(newDegrees)
		arrows[switchKey].set_rotation_degrees(newDegrees)

func _process(delta):
	
	if Input.is_action_just_pressed("1"):
		pass
	
	if Input.is_action_just_pressed("2"):
		pass

	if Input.is_action_just_pressed("3"):
		pass
		
	if Input.is_action_just_pressed("4"):
		pass
		
	if Input.is_action_just_pressed("q"):
		toggle("q")

	if Input.is_action_just_pressed("w"):
		toggle("w")

	if Input.is_action_just_pressed("e"):
		toggle("e")

	if Input.is_action_just_pressed("r"):
		toggle("r")

	if Input.is_action_just_pressed("a"):
		toggle("a")

	if Input.is_action_just_pressed("s"):
		toggle("s")

	if Input.is_action_just_pressed("d"):
		toggle("d")

	if Input.is_action_just_pressed("f"):
		toggle("f")

func toggle(switchKey):
	switchState[switchKey] = (switchState[switchKey] + 1) % 2
	var newDegrees = switchRot[switchKey][switchState[switchKey]]
	switches[switchKey].set_rotation_degrees(newDegrees)
	arrows[switchKey].set_rotation_degrees(newDegrees)








# end

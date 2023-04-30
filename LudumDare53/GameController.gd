extends Node

var waterTileNumToFacingLookup = {
	7: Vector2(0, -1),
	8: Vector2(1, 0),
	5: Vector2(0, 1),
	6: Vector2(-1, 0),
}

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

# starting from endMarker tile contains pointers to previous tiles
# {tileVecHash: [tileVec, ...]}
var tileLinkList = {}

func _ready():
	
	calculateTubeFlow()
	
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

func _process(_delta):
	
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

func hashTile(tilePos):
	return str(tilePos.x) + ":" + str(tilePos.y)

func posToTile(pos):
	var tilePos = Vector2(
		(pos.x - 32) / 64, 
		(pos.y - 32) / 64
	)
	return tilePos

# Populates tileLinkList for later use routing the tubes
func calculateTubeFlow():
	var endCell = posToTile($endMarker.position)
	tileLinkList = dfsReverseOrder(endCell)

# Starts from endCell, walks backward to startCell
# return array of cells from endCell to startCell
func dfsReverseOrder(endCell):
	var adj = [
		Vector2(0, -1), # up
		Vector2(1, 0),  # right
		Vector2(0, 1),  # down
		Vector2(-1, 0), # left
	]

	var switchSeen = {}
	var lst = []
	lst.push_back(endCell)

	while lst.size() > 0:
		var curTileVec = lst.pop_back()
		var curTileVecHash = hashTile(curTileVec)

		# If the curent tile is a switch
		# Mark it as seen as we won't need to visit again 
		if $Switch.get_cellv(curTileVec) != -1:
			if curTileVecHash in switchSeen:
				continue
			else:
				switchSeen[curTileVecHash] = true

		for offsetVec in adj:
			var nextTileVec = curTileVec + offsetVec
			var nextTileNumber = $Water.get_cellv(nextTileVec)
			if nextTileNumber != -1:
				var nextCellFacingVec = waterTileNumToFacingLookup[nextTileNumber]
				if -1 * offsetVec == nextCellFacingVec:
					lst.push_back(nextTileVec)
					if not (curTileVecHash in tileLinkList):
						 tileLinkList[curTileVecHash] = []
					tileLinkList[curTileVecHash].append(nextTileVec)

			# Check if it's a switch
			elif $Switch.get_cellv(nextTileVec) != -1:
				lst.push_back(nextTileVec)
				if not (curTileVecHash in tileLinkList):
					tileLinkList[curTileVecHash] = []
				tileLinkList[curTileVecHash].append(nextTileVec)
	
	return tileLinkList


# end

extends Node

var tubeScene = load("res://tube.tscn")

var waterTileNumToFacingLookup = {
	7: Vector2(0, -1), # up
	8: Vector2(1, 0),  # right
	5: Vector2(0, 1),  # down
	6: Vector2(-1, 0), # left
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

var tileVecHashToSwitchLetter = {}

var tubeSpawnLocations = []

# starting from endMarker tile contains pointers to previous tiles
# {tileVecHash: [tileVec, ...]}
var tileLinkList = {}

var rng = RandomNumberGenerator.new()

var tubeLocations = {}

var tubeTweenCount = 0

var shopLocations = {}

var reviewScore = 0.5

func _ready():
	rng.randomize()
	
	calculateTubeFlow()
	
	switches["q"] = $switches/qSwitch
	switches["w"] = $switches/wSwitch
	switches["e"] = $switches/eSwitch
	switches["r"] = $switches/rSwitch
	
	switches["a"] = $switches/aSwitch
	switches["s"] = $switches/sSwitch
	switches["d"] = $switches/dSwitch
	switches["f"] = $switches/fSwitch

	for s in switches:
		var switchTileVecHash = hashTile(posToTile(switches[s].position))
		tileVecHashToSwitchLetter[switchTileVecHash] = switches[s]

	var shops = [
		$shopLocations/groom,
		$shopLocations/movie,
		$shopLocations/wash,
		$shopLocations/review,
		$shopLocations/sushi,
		$shopLocations/burger
	]
	
	for s in shops:
		shopLocations[hashTile(posToTile(s.position))] = s.name

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
	
	tubeSpawnLocations.append($tubeSpawn/one)
	tubeSpawnLocations.append($tubeSpawn/two)
	tubeSpawnLocations.append($tubeSpawn/three)
	tubeSpawnLocations.append($tubeSpawn/four)
	
	spawnTube(1)
	
	tubeMove()
	$debugSpawn.start()

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

func unHashTile(tileHash):
	var lst = tileHash.split(":")
	var x = int(lst[0])
	var y = int(lst[1])
	return Vector2(x, y)

func posToTile(pos):
	var tilePos = Vector2(
		(pos.x - 32) / 64, 
		(pos.y - 32) / 64
	)
	return tilePos

func tileToPos(tileVec):
	var pos = Vector2(
		tileVec.x * 64 + 32, 
		tileVec.y * 64 + 32
	)
	return pos

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

func spawnTube(place):
	var spawnVec = tubeSpawnLocations[place - 1].position
	var spawnTileVec = posToTile(spawnVec)
	var spawnTileVecHash = hashTile(spawnTileVec)
	var tubeInstance = tubeScene.instance()
	tubeInstance.get_node("Tween").connect("tween_all_completed", self, "_tube_tween_completed")
	tubeLocations[spawnTileVecHash] = tubeInstance
	tubeInstance.set_position(spawnVec)
	tubeInstance.randomCatType()
	$tubes.add_child(tubeInstance)

func getWaterFacingDir(tileVec):
	var lookup = [
		Vector2(0, -1), # up
		Vector2(1, 0),  # right
		Vector2(0, 1),  # down
		Vector2(-1, 0), # left
	]
	var tileVecHash = hashTile(tileVec)
	var tileNumber = $Water.get_cellv(tileVec)
	if tileNumber == -1: # It's a switch
		var deg = floor(tileVecHashToSwitchLetter[tileVecHash].get_rotation_degrees() / 90)
		return lookup[deg]
	else: # Regular water tile
		return waterTileNumToFacingLookup[tileNumber]

func leaveReview(value):
	reviewScore += value
	# TODO - update review UI

func tubeMove():
	var tubeOrder = getTubeOrder()
	for tubeHash in tubeOrder:
		var tubeTileVec = unHashTile(tubeHash)
		var facingDir = getWaterFacingDir(tubeTileVec)
		var nextTileVec = tubeTileVec + facingDir
		var nextTileVecHash = hashTile(nextTileVec)
		if not (nextTileVecHash in tubeLocations):
			var tube = tubeLocations[tubeHash]
			tubeLocations.erase(tubeHash)
			tubeLocations[nextTileVecHash] = tube
			tubeTweenCount += 1
			
			if tubeHash in shopLocations:
				tube.visit(shopLocations[tubeHash])

			tube.move(
				tileToPos(tubeTileVec),
				tileToPos(nextTileVec)
			)

func _tube_tween_completed():
	tubeTweenCount -= 1
	if tubeTweenCount == 0:
		tubeMove()

func getTubeOrder():
	var tubeOrder = []
	var endTileVec = posToTile($endMarker.position)
	var endTileVecHash = hashTile(endTileVec)
	var seen = {}
	seen[endTileVecHash] = true
	var lst = []
	lst.push_back(endTileVecHash)
	while lst.size() > 0:

		var tileVecHash = lst.pop_front()

		if tileVecHash in tubeLocations:
			tubeOrder.append(tileVecHash)

		if tileVecHash in tileLinkList:
			var upstreamTileLst = shuffleList(tileLinkList[tileVecHash])
			for upstreamTileVec in upstreamTileLst:
				var upstreamTileVecHash = hashTile(upstreamTileVec)
				if not (upstreamTileVecHash in seen):
					seen[upstreamTileVecHash] = true
					lst.push_back(upstreamTileVecHash)

	return tubeOrder

func shuffleList(list):
	rng.randomize()
	var shuffledList = [] 
	var indexList = range(list.size())
	for _i in range(list.size()):
		var x = rng.randi() % indexList.size()
		shuffledList.append(list[indexList[x]])
		indexList.remove(x)
	return shuffledList

func _on_debugSpawn_timeout():
	rng.randomize()
	var lst = [1, 2, 3, 4]
	lst = shuffleList(lst)
	for i in range(rng.randi_range(0, 4)):
		spawnTube(lst[i])

extends Node2D

var catNumber
var wantsGroom
var wantsWash
var wantsMovie
var wantsBurger
var wantsSushi

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func move(fromVec, toVec):
	var tween = get_node("Tween")
	tween.interpolate_property(
		self, "position",
		fromVec, toVec, 
		4
	)
	tween.start()

func setCatType(catNumber, wantsWashParam, wantsMovieParam, wantsBurgerParam, wantsSushiParam):
	
	# wantsGroom is only for cat0
	wantsGroom  = false
	if catNumber == 0 and rng.randi(0, 2) == 0:
		wantsGroom  = true
	
	catNumber   = catNumber
	wantsWash   = wantsWashParam
	wantsMovie  = wantsMovieParam
	wantsBurger = wantsBurgerParam
	wantsSushi  = wantsSushiParam

	var catNumberLookup = [$cat0, $cat1, $cat2]
	catNumberLookup[catNumber].visible = true

	if wantsWash:
		$dirt.visible = true

	if wantsMovie:
		$glasses.visible = true

	if wantsBurger:
		$burger.visible = true

	if wantsSushi:
		$chopstick.visible = true

func randBool():
	return rng.randi_range(0, 1) == 0

func randomCatType():
	catNumber = rng.randi_range(0, 2)

	var values = [
		randBool(),
		randBool(),
		randBool(),
		randBool()
	]
	setCatType(catNumber, values[0], values[1], values[2], values[3])

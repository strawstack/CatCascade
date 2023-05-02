extends Node2D

var catNumber
var wantsGroom
var wantsWash
var wantsMovie
var wantsBurger
var wantsSushi
var isAngry = false

var rng = RandomNumberGenerator.new()

var tubeSpeed = null # get from gc

var gc
func _ready():
	gc = get_tree().get_root().get_node("main")
	tubeSpeed = gc.tubeSpeed
	rng.randomize()

func move(fromVec, toVec):
	var tween = get_node("Tween")
	tween.interpolate_property(
		self, "position",
		fromVec, toVec, 
		tubeSpeed
	)
	tween.start()

func feelHappy():
	pass

func feelAngry():
	isAngry = true
	$angry.visible = true

func visit(shopName):
	if shopName == "groom":
		if wantsGroom:
			wantsGroom = false
			$groom.visible = false
			feelHappy()
		else:
			feelAngry()
		
	elif shopName == "movie":
		if wantsMovie:
			wantsMovie = false
			$glasses.visible = false
			feelHappy()
		else:
			feelAngry()
		
	elif shopName == "wash":
		if wantsWash:
			wantsWash = false
			$dirt.visible = false
			feelHappy()
		else:
			feelAngry()
		
	elif shopName == "review":
		giveReview()

	elif shopName == "sushi":
		if wantsSushi:
			wantsSushi = false
			$chopstick.visible = false
			feelHappy()
		else:
			feelAngry()

	elif shopName == "burger":
		if wantsBurger:
			wantsBurger = false
			$burger.visible = false
			feelHappy()
		else:
			feelAngry()

func giveReview():
	var satis = (not wantsGroom) and (not wantsWash) and (not wantsMovie) and (not wantsBurger) and (not wantsSushi)
	if not satis and isAngry: 
		gc.leaveReview(-1)
	
	elif not satis and not isAngry:
		gc.leaveReview(-0.5)
	
	elif satis and isAngry:
		gc.leaveReview(-0.5)
	
	elif satis and not isAngry:
		gc.leaveReview(0.5)

func setCatType(catNumberParam, wantsWashParam, wantsMovieParam, wantsBurgerParam, wantsSushiParam):
	
	# wantsGroom is only for cat0
	wantsGroom  = false
	if catNumberParam == 0 and rng.randi_range(0, 2) == 0:
		wantsGroom  = true
		$groom.visible = true
	
	catNumber   = catNumberParam
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
	rng.randomize()
	catNumber = rng.randi_range(0, 2)
	setCatType(
		catNumber, 
		rng.randi_range(0, 1) == 0, 
		rng.randi_range(0, 1) == 0, 
		rng.randi_range(0, 1) == 0, 
		rng.randi_range(0, 1) == 0)

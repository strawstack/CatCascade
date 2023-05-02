extends Node2D

var half  = []
var full  = []

func _ready():
	half.push_back($half/star0)
	half.push_back($half/star1)
	half.push_back($half/star2)
	half.push_back($half/star3)
	half.push_back($half/star4)
	
	full.push_back($full/star0)
	full.push_back($full/star1)
	full.push_back($full/star2)
	full.push_back($full/star3)
	full.push_back($full/star4)
	
	clearAll()

func clearAll():
	for s in half:
		s.visible = false

	for s in full:
		s.visible = false

func updateReview(value):

	clearAll()
	var index = 1

	while index <= value:
		full[index - 1].visible = true
		index += 1

	if index != value + 1:
		half[index - 1].visible = true

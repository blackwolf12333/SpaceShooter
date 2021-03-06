extends Node2D

var backgroundSpeed = 100
var bottomY = 568

func _ready():
	set_process(true)

func _process(delta):
	var bg1_pos = get_node("background").get_pos()
	var bg2_pos = get_node("background2").get_pos()
	
	bg1_pos.y = bg1_pos.y + backgroundSpeed * delta
	bg2_pos.y = bg2_pos.y + backgroundSpeed * delta
	if bg1_pos.y > bottomY:
		bg1_pos.y = -bottomY + 15
	if bg2_pos.y > bottomY:
		bg2_pos.y = -bottomY + 15
	
	get_node("background").set_pos(bg1_pos)
	get_node("background2").set_pos(bg2_pos)

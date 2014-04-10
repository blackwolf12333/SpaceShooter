extends Node2D

#var menu = preload("menu.scn")

var laserCount = 0
var laserArray = []
var laserSpeed = 200

var rockCount = 0
var rockArray = []
var rockSpeed = 150
#var rock_class = preload("rock.gd").new()

var timeSinceLastRock = 0

var bottomY = 568
var topY = 0
var width = 320

var shipSpeed = 200

var isFirePressed = false

var backgroundSpeed = 100

var state = "game"

func _ready():
	set_process(true)

func _process(delta):
	if state == "menu":
		#menu._process(delta)
		pass
	elif state == "game":
		if Input.is_action_pressed("fire"):
			if isFirePressed == false:
				fire()
				isFirePressed = true
		else:
			isFirePressed = false
		
		var shipPosition = get_node("ship").get_pos()
		
		if Input.is_action_pressed("ui_left"):
			var newX = shipPosition.x - shipSpeed * delta
			if !(newX <= 0):
				shipPosition.x -= shipSpeed * delta
		if Input.is_action_pressed("ui_right"):
			var newX = shipPosition.x + shipSpeed * delta
			if !(newX >= width):
				shipPosition.x += shipSpeed * delta
		
		get_node("ship").set_pos(shipPosition)
		
		# laser processing
		var laserID = 0
		for laser in laserArray:
			var laserPos = get_node(laser).get_pos()
			laserPos.y -= laserSpeed*delta
			get_node(laser).set_pos(laserPos)
			if laserPos.y < 0:
				remove_and_delete_child(get_node(laser))
				laserArray.remove(laserID)
			laserID+=1
		
		#rock_class.process_rock(delta)
		# rock processing
		var rockID = 0
		for rock in rockArray:
			var rockPos = get_node(rock).get_pos()
			rockPos.y += rockSpeed*delta
			get_node(rock).set_pos(rockPos)
			# todo: handle destroy and game over logic
			if rockPos.y > bottomY:
				remove_and_delete_child(get_node(rock))
				rockArray.remove(rockID)
			rockID+=1
		
		
		var rockID = 0
		for rock in rockArray:
			var rockPos = get_node(rock).get_pos()
			var laserID = 0
			for laser in laserArray:
				var laserPos = get_node(laser).get_pos()
				if laserPos.y < rockPos.y:
					if laserPos.x > rockPos.x - 20:
						if laserPos.x < rockPos.x + 20:
							remove_and_delete_child(get_node(rock))
							rockArray.remove(rockID)
							remove_and_delete_child(get_node(laser))
							laserArray.remove(laserID)
							get_node("rock_sound").play("smallexplosion1")
				laserID+=1
			
			var shipPos = get_node("ship").get_pos()
			if rockPos.y > 485:
				if rockPos.x + 20 > shipPos.x - 40:
					if rockPos.x - 20 < shipPos.x + 40:
						gameOver()
			rockID+=1
		
		timeSinceLastRock += delta
		if timeSinceLastRock > 0.5:
			newRock()
			timeSinceLastRock = 0
		moveBackground(delta)

func moveBackground(delta):
	var back1 = get_node("background").get_pos()
	var back2 = get_node("background2").get_pos()
	back1.y = back1.y + backgroundSpeed * delta
	back2.y = back2.y + backgroundSpeed * delta
	if back1.y > bottomY:
		back1.y = -bottomY + 15
	if back2.y > bottomY:
		back2.y = -bottomY + 15
	get_node("background").set_pos(back1)
	get_node("background2").set_pos(back2)

func fire():
	laserCount += 1
	print("Fire!")
	var laser_instance = get_node("laser").duplicate()
	laser_instance.set_name("laser"+str(laserCount))
	add_child(laser_instance)
	var sound = get_node("laser_sound")
	sound.play("laser")
	
	var laserPos = get_node("laser"+str(laserCount)).get_pos()
	laserPos.x = get_node("ship").get_pos().x
	laserPos.y = 500
	laser_instance.set_pos(laserPos)
	laserArray.push_back("laser"+str(laserCount))

func newRock():
	rockCount += 1
	print("New Rock!")
	var rock_instance = get_node("rock").duplicate()
	rock_instance.set_name("rock"+str(rockCount))
	add_child(rock_instance)
	
	var rockPos = get_node("rock"+str(rockCount)).get_pos()
	rockPos.x = rand_range(0, 320)
	rockPos.y = -10
	rock_instance.set_pos(rockPos)
	rockArray.push_back("rock"+str(rockCount))

func gameOver():
	print("Game Over!")
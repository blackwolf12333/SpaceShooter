extends Sprite

var rockCount = 0
var rockArray = []
var rockSpeed = 150

var timeSinceLastRock = 0

var bottomY = 568
var topY = 0
var width = 320

func process_rock(delta):
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
	timeSinceLastRock += delta
	if timeSinceLastRock > 0.5:
		newRock()
		timeSinceLastRock = 0

func newRock():
	rockCount += 1
	print("New Rock!2")
	var rock_instance = duplicate()
	rock_instance.set_name("rock"+str(rockCount))
	add_child(rock_instance)
	
	var rockPos = rock_instance.get_pos()
	rockPos.x = rand_range(0, 320)
	rockPos.y = -10
	rock_instance.set_pos(rockPos)
	rockArray.push_back("rock"+str(rockCount))

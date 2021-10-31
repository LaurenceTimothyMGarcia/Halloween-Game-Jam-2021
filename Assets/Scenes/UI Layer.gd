extends CanvasLayer


# Declare member variables here. Examples:
export var playerMaxHP = 10
export var playerBarCoefficient = 21

export var boxMaxHP = 6
export var boxBarCoefficient = 35

export var barMin = 45
export var barMax = 255

export (String, FILE, "*.json") var dialogue_file_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerHPBar.value = barMax
	$"PlayerHPBar/BoxHPBar".value = barMax
	# DialogueBox.hide()
	var dialogue =  load_dialogue(dialogue_file_path)
	$DialogueBox.start(dialogue)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_lost_health(newamt):
	$PlayerHPBar.value = newamt * playerBarCoefficient + barMin


func _on_The_Box_lost_health(newamt):
	$"PlayerHPBar/BoxHPBar".value = newamt * boxBarCoefficient + barMin
	if newamt <= 2:
		$BoxIcon3.visible = true
	elif newamt <= 4:
		$BoxIcon2.visible = true


func _on_Player_key_amt_changed(newamt):
	$"KeySprite/KeyCounter".text = str(newamt)

func load_dialogue(var file_path) -> Dictionary:
	# Parses a JSON file and returns it as a dictionary
	var file = File.new()
	assert(file.file_exists(file_path))

	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	return dialogue

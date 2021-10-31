extends Node


# Declare member variables here. Examples:
export (String, FILE, "*.json") var dialogue_file_path: String


# Called when the node enters the scene tree for the first time.
func _ready():
	var dialogue =  load_dialogue(dialogue_file_path)
	$"../UI Layer/DialogueBox".call("start", dialogue)
	yield($"../UI Layer/DialogueBox", "dialogue_ended")


func load_dialogue(var file_path) -> Dictionary:
	# Parses a JSON file and returns it as a dictionary
	var file = File.new()
	assert(file.file_exists(file_path))

	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	return dialogue

extends Control
class_name DialogueBox

signal dialogue_ended



func start(var dialogue):
	print("pee")
	# Reinitializes the UI and asks the DialoguePlayer to 
	# play the dialogue
	$Panel/ButtonFinished.hide()
	$Panel/ButtonNext.show()
	$Panel/ButtonNext.grab_focus()
	$Panel/ButtonNext.text = "Next"
	$DialoguePlayer.start(dialogue)
	update_content()
	show()


func _on_ButtonNext_pressed():
	$DialoguePlayer.next()
	update_content()


func _on_DialoguePlayer_finished():
	$Panel/ButtonNext.hide()
	$Panel/ButtonFinished.grab_focus()
	$Panel/ButtonFinished.show()


func _on_ButtonFinished_pressed():
	emit_signal("dialogue_ended")
	hide()


func update_content():
	var dialogue_player_name = $DialoguePlayer.title
	$Panel/Name.text = dialogue_player_name
	$Panel/Text.text = $DialoguePlayer.text
	$Portrait.texture = $DialogueDatabase.get_texture(
		dialogue_player_name, $DialoguePlayer.expression
	)

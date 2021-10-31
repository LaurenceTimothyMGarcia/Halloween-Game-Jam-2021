extends Control
export(PackedScene) var target_scene

func _ready():
	$MainTheme.play()

func _on_Start_pressed():
	get_tree().change_scene_to(target_scene)




func _on_About_pressed():
	get_tree().change_scene("res://Assets/Levels/AboutPage.tscn")


func _on_Quit_pressed():
	get_tree().quit()

extends Area2D

signal scene_changed()
export(PackedScene) var target_scene

func change_scene(path):
	assert(get_tree().change_scene(path) == OK)
	get_tree().change_scene(path)
	emit_signal("scene_changed")

func _on_Area2D_body_entered(body):
	print("Touched")
	if body.is_in_group("thebox"):
		print("Box Touched")
		get_tree().change_scene_to(target_scene)

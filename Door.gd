extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.has_method("useKey") and body.numKeys > 0:
		body.useKey()
		queue_free()

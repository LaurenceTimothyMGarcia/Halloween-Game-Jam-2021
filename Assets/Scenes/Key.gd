extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_keyHitBox_body_entered(body):
	if body.has_method("collectKey"):
		body.collectKey()
		queue_free()

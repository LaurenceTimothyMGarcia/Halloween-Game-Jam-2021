extends Area2D


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.call("getHurt", true, 10000)
	if body.is_in_group("thebox"):
		body.call("getHurt", 10000)
	if body.is_in_group("enemies"):
		body.call("getHurt", 10000)

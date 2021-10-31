extends Area2D


export var vel = 200;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (Vector2.RIGHT*vel).rotated(rotation) * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()	#delete off screen bullets

func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		return
	if body.has_method("getHurt"):
		body.getHurt(1)
	queue_free()

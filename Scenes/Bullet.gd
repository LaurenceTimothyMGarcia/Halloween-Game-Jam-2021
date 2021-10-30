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
	
func take_damage():
	queue_free()

extends Node2D

var can_fire = true

export (PackedScene) var bullet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	var mousePos = get_global_mouse_position()
	look_at(mousePos)
	
	if Input.is_action_pressed("shoot") and can_fire and !get_parent().holdingBox:

		var bulletInstance = bullet.instance()
		bulletInstance.position = $MuzzleArea.global_position 
		bulletInstance.rotation = rotation
		get_parent().add_child(bulletInstance)
		can_fire = false
		$AudioStreamPlayer2D.play()
		yield(get_tree().create_timer(0.3), "timeout")
		can_fire = true
		

extends Node2D

var can_fire = true

<<<<<<< HEAD:Assets/Scenes/Gun/Gun.gd
export (PackedScene) var bullet
=======
var bullet = preload("res://Assets/Scenes/GunScenes/Bullet.tscn")
>>>>>>> Brayden:Assets/Scenes/GunScenes/Gun.gd

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	position.x = get_parent().position.x + 31
	position.y = get_parent().position.y + 5
	
	var mousePos = get_global_mouse_position()
	look_at(mousePos)
	
	if Input.is_action_pressed("shoot") and can_fire:

		var bulletInstance = bullet.instance()
		bulletInstance.position = $MuzzleArea.global_position 
		bulletInstance.rotation = rotation
		get_parent().add_child(bulletInstance)
		can_fire = false
		yield(get_tree().create_timer(0.3), "timeout")
		can_fire = true
		

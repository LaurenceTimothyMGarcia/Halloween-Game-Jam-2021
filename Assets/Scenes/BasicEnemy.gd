extends KinematicBody2D

var gravity = 10
var velocity = Vector2()
var is_moving_left = true

export var speed = 100
export var hitHealth = 1;

#func _ready():
	#$AnimationPlayer.play("Walk")

func _process(delta):
	move_character()
	detect_turn_around()
	print(hitHealth)

func move_character():
	if is_moving_left:
		velocity.x = -speed
	else:
		velocity.x = speed
	
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x

func hit():
	hitHealth -= 1
	if hitHealth == 0:
		queue_free()
	

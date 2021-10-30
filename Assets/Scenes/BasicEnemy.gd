extends KinematicBody2D

var gravity = 10
var velocity = Vector2()
var is_moving_left = true

export var speed = 100

#func _ready():
	#$AnimationPlayer.play("Walk")

func _process(delta):
	move_character()
	detect_turn_around()

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
	$AttackDetector.monitoring = true
	print("Hit player")

func end_of_hit():
	$AttackDetector.monitoring = false

#func start_walk(): go back to tutorial to connect things
	#$AnimationPlayer.play("Walk")

#func _on_PlayerDetector_body_entered(body):
	#$AnimationPlayer.play("Attack")

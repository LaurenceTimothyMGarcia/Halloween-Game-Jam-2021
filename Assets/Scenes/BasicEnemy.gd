extends KinematicBody2D

var is_moving_left = true

var gravity = 1000
var velocity = Vector2(0, 0)

var speed = 400

#func _ready():
	#$AnimationPlayer.play("Walk")

func _process(delta):
	if $AnimationPlayer.current_animation == "Attack":
		return
	
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
		print("Time to turn around")

func hit():
	$AttackDetector.monitoring = true

func end_of_hit():
	$attackDetector.monitoring = false

#func start_walk():
	#AnimationPlayer.play("Walk")
	
#func _on_PlayerDetector_body_entered(body):
	#animation attack

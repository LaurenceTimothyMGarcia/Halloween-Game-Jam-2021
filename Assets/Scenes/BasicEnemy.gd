extends KinematicBody2D

var gravity = 10
var velocity = Vector2()
var is_moving_left = true

export var speed = 100
export var maxHP = 3;
var _currentHP

func _ready():
	$AnimationPlayer.play("WalkLeft")
	_currentHP = maxHP

func _process(delta):
	if $AnimationPlayer.current_animation == "AttackLeft":
		return
	move_character()
	detect_turn_around()
	_checkDead()

func move_character():
	if is_moving_left:
		$AnimationPlayer.play("WalkLeft")
		velocity.x = -speed
	else:
		$AnimationPlayer.play("WalkLeft")
		velocity.x = speed
	
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x

func takeDamage(var amount):
	_currentHP = clamp(_currentHP - amount, 0, maxHP)

func _tryDying():
	if (_currentHP == 0):
		print("fuck")
		takeDamage(-100)

func _checkDead():
	if _currentHP == 0:
		queue_free()

func getHurt(var amount):
	$AnimationPlayer.play("GetHurt")
	takeDamage(amount)

func hit():
	$AttackDetector.monitoring = true

func end_of_hit():
	$AttackDetector.monitoring = false

func start_walk():
	$AnimationPlayer.play("LeftWalk")

func _on_PlayerDetector_body_entered(body):
	$AnimationPlayer.play("AttackLeft")


func _on_AttackDetector_body_entered(body):
	if body.is_in_group("player"):
		body.call("getHurt", !is_moving_left, 1)
	if body.is_in_group("thebox"):
		body.call("getHurt", 1)

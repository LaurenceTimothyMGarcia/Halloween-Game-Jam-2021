extends KinematicBody2D


# Declare member variables here.
export var walkSpeed = 400
export var jumpVel = 500
export var gravity = 1000
export var fallMultiplier = 2
export var lowJumpMultiplier = 4

var _jumpReady

var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	_jumpReady = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_movementHandler(delta)

func _movementHandler(var delta):
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_just_pressed("jump") and _jumpReady:
		_jumpReady = false
		velocity.y = -jumpVel

	if velocity.y > 0:
		velocity.y += gravity * delta * (fallMultiplier - 1)
	elif velocity.y < 0 and !Input.is_action_pressed("jump"):
		velocity.y += gravity * delta * (lowJumpMultiplier - 1)
	else:
		velocity.y += gravity * delta

	velocity.x *= walkSpeed
	
	velocity = move_and_slide(velocity)


func _on_GroundedChecker_body_entered(body):
	if body.is_in_group("platforms"):
		_jumpReady = true

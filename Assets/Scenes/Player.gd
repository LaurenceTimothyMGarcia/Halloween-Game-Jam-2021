extends KinematicBody2D


# Declare member variables here.
export var walkSpeed = 200
export var jumpVel = 100
export var gravity = 50

var _jumpReady

var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	_jumpReady = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_movementHandler(delta)

func _movementHandler(var delta):
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_just_pressed("jump") and _jumpReady:
		velocity.y = -jumpVel
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity)

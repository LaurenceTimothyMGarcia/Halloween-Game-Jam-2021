extends KinematicBody2D


# Declare member variables here.
export var walkSpeed = 200
export var jumpVel = 400
export var gravity = 1000
export var fallMultiplier = 2
export var lowJumpMultiplier = 4

enum boxState {platform, carried, thrown}

var _jumpReady

var _facingRight
var _grabPointSwapDistance

var theBox

signal facing_left
signal facing_right

var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	_jumpReady = true
	_facingRight = true
	_grabPointSwapDistance = $GrabPoint.position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_lookAtMouse()
	_movementHandler(delta)
	_theBoxHandler()

func _lookAtMouse():
	if get_global_mouse_position().x >= position.x:
		_lookRight()
	else:
		_lookLeft()

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

func _lookLeft():
	if _facingRight:
		_facingRight = false
		$GrabPoint.position.x = -_grabPointSwapDistance
		$GrabZone.scale *= -1
		$Gun.position.x *= -1
		$Sprite.scale.x *= -1
		emit_signal("facing_left")

func _lookRight():
	if !_facingRight:
		_facingRight = true
		$GrabPoint.position.x = _grabPointSwapDistance
		$GrabZone.scale *= -1
		$Gun.position.x *= -1
		$Sprite.scale.x *= -1
		emit_signal("facing_right")

func _on_GroundedChecker_body_entered(body):
	if body.is_in_group("platforms"):
		_jumpReady = true


func _theBoxHandler():
	if Input.is_action_just_pressed("grab") and theBox != null:
		if theBox.currentState == boxState.platform:
			theBox.call("getPickedUp", $GrabPoint, _grabPointSwapDistance)
			connect("facing_left", theBox, "_on_Player_facing_left")
			connect("facing_right", theBox, "_on_Player_facing_right")
			theBox.facingRight = _facingRight
		elif theBox.currentState == boxState.carried:
			disconnect("facing_left", theBox, "_on_Player_facing_left")
			disconnect("facing_right", theBox, "_on_Player_facing_right")
			theBox.call("getThrown")

func _on_GrabZone_body_entered(body):
	if body.is_in_group("thebox"):
		theBox = body

func _on_GrabZone_body_exited(body):
	if body.is_in_group("thebox"):
		theBox = null

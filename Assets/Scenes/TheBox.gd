extends RigidBody2D


# Declare member variables here.
export var latchSpeed = 500

enum boxState {platform, carried, thrown}
var currentState

var targetPos
var _moveDir

signal box_grabbed
signal box_thrown

# Called when the node enters the scene tree for the first time.
func _ready():
	currentState = boxState.platform
	_moveDir = Vector2()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	movementHandler(delta)

func _enterCarriedMode():
	if currentState == boxState.platform:
		currentState = boxState.carried
		call_deferred("set_mode",MODE_STATIC)
		# $Hitbox.disabled = true

func _enterThrownMode():
	if currentState == boxState.carried:
		currentState = boxState.thrown
		call_deferred("set_mode",MODE_CHARACTER)
		$Hitbox.disabled = false
		linear_velocity = Vector2(100,-20)

func _enterPlatformMode():
	if currentState == boxState.thrown:
		currentState = boxState.platform
		call_deferred("set_mode",MODE_STATIC)

# this is the function that player can call in order to pick up the box
func getPickedUp(var grabPoint):
	if currentState == boxState.platform:
		emit_signal("box_grabbed")
		targetPos = grabPoint
		_enterCarriedMode()

func getThrown():
	if currentState == boxState.carried:
		emit_signal("box_thrown")
		_enterThrownMode()

func _on_GroundedChecker_body_entered(body):
	if currentState == boxState.thrown and body.is_in_group("platforms"):
		_enterPlatformMode()

func movementHandler(delta):
	if currentState == boxState.carried:
		position = position.move_toward(targetPos.position, latchSpeed * delta)

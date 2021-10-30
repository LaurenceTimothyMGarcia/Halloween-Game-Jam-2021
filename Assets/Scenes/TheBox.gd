extends RigidBody2D


# Declare member variables here.
export var latchSpeed = 2000

enum boxState {platform, carried, thrown}
var currentState

var targetPos
var _moveDir

var swapSideDist

var facingRight

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
		call_deferred("set_mode",MODE_KINEMATIC)
		remove_from_group("platforms")
		# $Hitbox.disabled = true

func _enterThrownMode():
	if currentState == boxState.carried:
		currentState = boxState.thrown
		call_deferred("set_mode",MODE_CHARACTER)
		# $Hitbox.disabled = false
		if facingRight:
			linear_velocity = Vector2(400,-20)
		else:
			linear_velocity = Vector2(-400,-20)

func _enterPlatformMode():
	if currentState == boxState.thrown:
		currentState = boxState.platform
		call_deferred("set_mode",MODE_STATIC)
		add_to_group("platforms")

# this is the function that player can call in order to pick up the box
func getPickedUp(var grabPoint, var grabPointDist):
	if currentState == boxState.platform:
		emit_signal("box_grabbed")
		targetPos = grabPoint
		swapSideDist = grabPointDist
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
		position = position.move_toward(targetPos.get_global_position(), latchSpeed * delta)

func _on_Player_facing_left():
	if currentState == boxState.carried:
		position.x -= 2 * swapSideDist
		facingRight = false

func _on_Player_facing_right():
	if currentState == boxState.carried:
		position.x += 2 * swapSideDist
		facingRight = true

extends KinematicBody2D


# Declare member variables here.
export var walkSpeed = 200
export var jumpVel = 500
export var gravity = 1000
export var fallMultiplier = 2
export var lowJumpMultiplier = 4
export var knockedBackSpeed = 200
export var knockedBackUp = 200

export var maxHP = 10
var _currentHP

enum boxState {platform, carried, thrown}


var _jumpReady

var _facingRight
var _grabPointSwapDistance

var theBox

var holdingBox

var _stunned
var _knockedBack
var _invincible
var numKeys = 0

signal facing_left
signal facing_right

signal lost_health(newamt)
signal key_amt_changed(newamt)

var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	_jumpReady = true
	_facingRight = true
	holdingBox = false
	_stunned = false
	_knockedBack = false
	_invincible = false
	_grabPointSwapDistance = $GrabPoint.position.x
	_currentHP = maxHP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_stunnedHandler(delta)
	if !_stunned:
		_lookAtMouse()
		_movementHandler(delta)
		_theBoxHandler()
	_tryDying()

func _stunnedHandler(var delta):
	if _stunned:
		velocity.x = 0
		if _knockedBack:
			if _facingRight:
				velocity.x -= 1
			else:
				velocity.x += 1
		velocity.x *= knockedBackSpeed
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity)
	if _invincible:
		$Sprite.modulate = Color(1,1,1,.25)
		$"Gun/Sprite".modulate = Color(1,1,1,.25)
	else:
		$Sprite.modulate = Color(1,1,1,1)
		$"Gun/Sprite".modulate = Color(1,1,1,1)

func _lookAtMouse():
	if get_global_mouse_position().x >= position.x:
		_lookRight()
	else:
		_lookLeft()

func _movementHandler(var delta):
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$AnimationPlayer.play("Walk_Left")
	elif Input.is_action_pressed("move_right"):
		velocity.x += 1
		$AnimationPlayer.play("Walk_Right")
	else:
		$AnimationPlayer.play("Idle")
	
	
	if Input.is_action_just_pressed("jump") and _jumpReady:
		_jumpReady = false
		velocity.y = -jumpVel
		$AnimationPlayer.play("Jump")

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
		$GrabZone.position.x *= -1
		$Gun.position.x *= -1
		$"Gun/Sprite".scale.y *= -1
		$Sprite.scale.x *= -1
		emit_signal("facing_left")

func _lookRight():
	if !_facingRight:
		_facingRight = true
		$GrabPoint.position.x = _grabPointSwapDistance
		$GrabZone.scale *= -1
		$GrabZone.position.x *= -1
		$Gun.position.x *= -1
		$"Gun/Sprite".scale.y *= -1
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
			holdingBox = true
			$"Gun/Sprite".visible = false
		elif theBox.currentState == boxState.carried:
			_throwBox()

func _throwBox():
	if holdingBox:
		disconnect("facing_left", theBox, "_on_Player_facing_left")
		disconnect("facing_right", theBox, "_on_Player_facing_right")
		theBox.call("getThrown")
		holdingBox = false
		$"Gun/Sprite".visible = true

func _on_GrabZone_body_entered(body):
	if body.is_in_group("thebox"):
		theBox = body

func _on_GrabZone_body_exited(body):
	if body.is_in_group("thebox"):
		theBox = null

func takeDamage(var amount):
	_currentHP = clamp(_currentHP - amount, 0, maxHP)
	emit_signal("lost_health", _currentHP)

func _tryDying():
	if (_currentHP == 0):
		print("fuck")
		takeDamage(-100)

func getHurt(var fromLeft, var amount):
	if not _invincible:
		if fromLeft:
			_lookLeft()
		else:
			_lookRight()
		
		call_deferred("_throwBox")
		
		$AnimationPlayer.play("Hit")
		
		takeDamage(amount)
		
		_stunned = true
		_knockedBack = true
		_invincible = true
		velocity.y = -knockedBackUp
		
		$StunTimer.start()
		$KnockbackTimer.start()
		$InvincibleTimer.start()


func _on_StunTimer_timeout():
	_stunned = false


func _on_KnockbackTimer_timeout():
	_knockedBack = false


func _on_InvincibleTimer_timeout():
	_invincible = false
		
func collectKey():
	numKeys += 1
	emit_signal("key_amt_changed", numKeys)
	
func useKey():
	numKeys -= 1
	emit_signal("key_amt_changed", numKeys)

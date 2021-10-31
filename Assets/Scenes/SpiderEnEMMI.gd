extends KinematicBody2D


# Declare member variables here. 
enum spiderState {dormant,hunting,ready,striking}
enum boxState {platform, carried, thrown}

var currentState
export var gravityAmount = 500
export var crawlMaxSpeed = 200
export var crawlAccel = 10
export var maxHP = 5;
var _currentHP
var _actualGravity
var facingRight
var hasLanded

var theBox
var thePlayer

var aggroTarget
var targetOutOfRange

var strikeReady

var velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	_actualGravity = -gravityAmount # spider starts dormant sticking to ceiling
	facingRight = true
	hasLanded = false
	targetOutOfRange = true
	strikeReady = true
	currentState = spiderState.dormant
	velocity = Vector2(0,0)
	_currentHP = maxHP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	dormantHandler(delta)
	chooseAggroTarget()
	faceTarget()
	chaseHandler(delta)
	_collisionHandler()

func dormantHandler(var delta):
	if currentState == spiderState.dormant:
		velocity.x = 0
		velocity.y += _actualGravity * delta
		velocity = move_and_slide(velocity,Vector2(0,-1))

func chooseAggroTarget():
	if theBox != null:
		if theBox.currentState == boxState.carried:
			aggroTarget = thePlayer
		else:
			aggroTarget = theBox

func faceTarget():
	if aggroTarget != null:
		if position.x < aggroTarget.position.x:
			_lookRight()
		else:
			_lookLeft()

func _lookRight():
	if not facingRight:
		facingRight = true

func _lookLeft():
	if facingRight:
		facingRight = false

func chaseHandler(var delta):
	if currentState == spiderState.hunting:
		if is_on_wall():
			$AnimationPlayer.play("Climb")
			_actualGravity = 0
			velocity.y = -crawlMaxSpeed
		else:
			_actualGravity = gravityAmount
		if hasLanded and facingRight and velocity.x <= crawlMaxSpeed:
			$AnimationPlayer.play("RightWalk")
			velocity.x += crawlAccel
		elif hasLanded and !facingRight and velocity.x >= -crawlMaxSpeed:
			$AnimationPlayer.play("LeftWalk")
			velocity.x -= crawlAccel
		if !hasLanded:
			$AnimationPlayer.play("Ceiling")
		if is_on_floor():
			hasLanded = true
		
		velocity.y += _actualGravity * delta
		velocity = move_and_slide(velocity,Vector2(0,-1))

func _collisionHandler():
	if currentState == spiderState.hunting:
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.get_collider() == theBox:
				_slamBox()
			elif collision.get_collider() == thePlayer:
				_slamPlayer()

func _slamBox():
	if theBox.currentState == boxState.carried:
		thePlayer.call("getHurt", facingRight, 1)
	theBox.call("getHurt", 1)
	if facingRight:
		velocity.x = 2 * -crawlMaxSpeed
	else:
		velocity.x = 2 * crawlMaxSpeed

func _slamPlayer():
	thePlayer.call("getHurt", facingRight, 1)
	if facingRight:
		velocity.x = 2 * -crawlMaxSpeed
	else:
		velocity.x = 2 * crawlMaxSpeed

func _on_AggroZone_body_entered(body):
	if body.is_in_group("player"):
		if body.holdingBox:
			thePlayer = body
			theBox = body.theBox
			currentState = spiderState.hunting

func takeDamage(var amount):
	_currentHP = clamp(_currentHP - amount, 0, maxHP)

func _tryDying():
	if (_currentHP == 0):
		print("fuck")
		takeDamage(-100)

func getHurt(var amount):
	$AnimationPlayer.play("GetHurt")
	takeDamage(amount)

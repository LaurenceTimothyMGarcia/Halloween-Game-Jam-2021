extends CanvasLayer


# Declare member variables here. Examples:
export var playerMaxHP = 10
export var playerBarCoefficient = 21

export var boxMaxHP = 6
export var boxBarCoefficient = 35

export var barMin = 45
export var barMax = 255

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerHPBar.value = barMax
	$"PlayerHPBar/BoxHPBar".value = barMax
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_lost_health(newamt):
	$PlayerHPBar.value = newamt * playerBarCoefficient + barMin


func _on_The_Box_lost_health(newamt):
	$"PlayerHPBar/BoxHPBar".value = newamt * boxBarCoefficient + barMin


func _on_Player_key_amt_changed(newamt):
	$"KeySprite/KeyCounter".text = str(newamt)

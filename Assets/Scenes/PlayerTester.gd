extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Button_pressed():
	$Player.getHurt(false,1)


func _on_BoxButton_pressed():
	$"The Box".takeDamage(1)

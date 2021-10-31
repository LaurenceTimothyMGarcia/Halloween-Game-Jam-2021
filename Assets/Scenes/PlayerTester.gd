extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"UI Layer/Label".text = "HP: " + str($Player.maxHP)
	$"UI Layer/BoxLabel".text = "Box HP: " + str($"The Box".maxHP)


func _process(delta):
	$"UI Layer/Label".text = "HP: " + str($Player._currentHP)
	$"UI Layer/BoxLabel".text = "Box HP: " + str($"The Box"._currentHP)



func _on_Button_pressed():
	$Player.getHurt(false,1)


func _on_BoxButton_pressed():
	$"The Box".takeDamage(1)

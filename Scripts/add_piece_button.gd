extends Button

@export var button_icon:Texture2D
var count:int = 0

func _on_pressed():
	count += 1

func _ready():
	icon = button_icon							# Set the button icon

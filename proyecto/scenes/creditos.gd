extends CanvasLayer


onready var back_button=$Back


func _ready():
	back_button.connect("pressed", self, "on_back_pressed")

func on_back_pressed():
	get_tree().change_scene("res://scenes/menu.tscn")

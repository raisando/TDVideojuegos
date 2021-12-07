extends CanvasLayer


onready var play_button=$VBoxContainer/Play
onready var Credits_button=$VBoxContainer/Credits
onready var Quit_button=$VBoxContainer/Quit

func _ready():
	play_button.connect("pressed", self, "on_play_pressed")
	Credits_button.connect("pressed", self, "on_credits_pressed")
	Quit_button.connect("pressed", self, "on_quit_pressed")


func on_play_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func on_credits_pressed():
	get_tree().change_scene("res://scenes/creditos.tscn")
	
func on_quit_pressed():
	get_tree().quit()

extends CanvasLayer


onready var lobby_button=$MarginContainer/VBoxContainer/Lobby
onready var Credits_button=$MarginContainer/VBoxContainer/Credits
onready var Quit_button=$MarginContainer/VBoxContainer/Quit

func _ready():
	lobby_button.connect("pressed", self, "on_lobby_pressed")
	Credits_button.connect("pressed", self, "on_credits_pressed")
	Quit_button.connect("pressed", self, "on_quit_pressed")


func on_lobby_pressed():
	LevelManager.change_scene(2) # Lobby

func on_credits_pressed():
	LevelManager.change_scene(1) # Créditos
	
func on_quit_pressed():
	get_tree().quit()
